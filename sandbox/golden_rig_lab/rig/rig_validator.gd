class_name RigValidator
extends RefCounted
## Automated checks from VALIDATION_RULES.md that can run inside the Lab, plus LAB-prefixed
## fit diagnostics (not contract codes) derived from part metadata vs manifest markers.

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const RigBuilderScript = preload("res://rig/rig_builder.gd")
const VisualPartScript = preload("res://rig/visual_part.gd")
const VisualAssemblerScript = preload("res://rig/visual_assembler.gd")

var errors: Array[Dictionary] = []
var warnings: Array[Dictionary] = []
var fit: Array[Dictionary] = []   # per slot diagnostics
var _image_cache: Dictionary = {}  # texture path -> {"alpha_none": bool, "used": Rect2i, "size": Vector2i}


func run(manifest: RigManifestScript, skeleton: Skeleton2D, assembler: VisualAssemblerScript) -> Dictionary:
	errors.clear()
	warnings.clear()
	fit.clear()
	for e in manifest.errors:
		_add(errors, e.substr(0, 5), "", e)
	for e in RigBuilderScript.verify(manifest, skeleton):
		_add(errors, e.substr(0, 5), "", e)
	if bool(manifest.rules.get("runtime_ik_allowed", false)):
		_add(errors, "GR024", "", "manifest allows runtime IK")
	for p in assembler.problems:
		var is_warning: bool = p["code"] in ["GR043", "GR052", "MIRROR"]
		_add(warnings if is_warning else errors, p["code"], p["slot"], p["message"])
	for slot in assembler.parts:
		_check_part(manifest, assembler, assembler.parts[slot])
	return {"ok": errors.is_empty(), "errors": errors, "warnings": warnings, "fit": fit}


## Reads the file signature of the untouched source: "png", "jpeg", "missing" or the hex prefix.
func _container_signature(tex_path: String) -> String:
	var f := FileAccess.open(tex_path, FileAccess.READ)
	if f == null:
		return "missing"
	var head: PackedByteArray = f.get_buffer(8)
	if head.size() >= 8 and head[0] == 0x89 and head[1] == 0x50 and head[2] == 0x4E and head[3] == 0x47:
		return "png"
	if head.size() >= 2 and head[0] == 0xFF and head[1] == 0xD8:
		return "jpeg"
	return head.hex_encode()


func _image_info(tex_path: String) -> Dictionary:
	if _image_cache.has(tex_path):
		return _image_cache[tex_path]
	var info := {}
	var img := Image.new()
	var err := ERR_FILE_UNRECOGNIZED
	if FileAccess.file_exists(tex_path):
		var bytes := FileAccess.get_file_as_bytes(tex_path)
		match _container_signature(tex_path):
			"png":
				err = img.load_png_from_buffer(bytes)
			"jpeg":
				err = img.load_jpg_from_buffer(bytes)
	if err == OK:
		info = {
			"alpha_none": img.detect_alpha() == Image.ALPHA_NONE,
			"used": img.get_used_rect(),
			"size": Vector2i(img.get_width(), img.get_height()),
		}
	_image_cache[tex_path] = info
	return info


func _check_part(manifest: RigManifestScript, assembler: VisualAssemblerScript, part: VisualPartScript) -> void:
	var slot: String = part.slot
	for view in manifest.authored_views:
		if not part.has_view(view):
			_add(warnings, "GR010", slot, "view %s not authored yet (expected at this gate for back_3q)" % view)
	if not part.has_view(assembler.current_view):
		return
	var vm: Dictionary = part.view(assembler.current_view)
	var tex_path := str(vm.get("texture", ""))
	var source_size := VisualPartScript.v2(vm.get("source_size"))
	var pivot := VisualPartScript.v2(vm.get("pivot_source"))
	var s := float(vm.get("scale_to_logical", 1.0))
	if source_size != manifest.canvas_size:
		_add(errors, "GR011", slot, "normalized pilot PNG is not 512x512 (raw candidate %dx%d placed through scale_to_logical=%.4f; allowed only during P2.4B normalization)" % [int(source_size.x), int(source_size.y), s])
	if pivot.x < 0 or pivot.y < 0 or pivot.x > source_size.x or pivot.y > source_size.y:
		_add(errors, "GR013", slot, "pivot_source %s outside source canvas" % pivot)
	var pm := str(vm.get("pivot_marker", ""))
	if pm != "" and not manifest.has_marker(pm):
		_add(errors, "GR020", slot, "pivot_marker %s unknown" % pm)
	var container := _container_signature(tex_path)
	if container == "jpeg":
		_add(errors, "GR012", slot, "source container is JPEG (signature ffd8), cannot carry alpha (%s)" % tex_path.get_file())
	elif container != "png":
		_add(errors, "GR012", slot, "source container is not PNG (%s: %s)" % [tex_path.get_file(), container])
	var info := _image_info(tex_path)
	if info.is_empty():
		_add(errors, "GR003", slot, "cannot read source image %s" % tex_path)
	else:
		if bool(info["alpha_none"]):
			_add(errors, "GR012", slot, "source has no alpha/RGBA (%s)" % tex_path.get_file())
		else:
			var used: Rect2i = info["used"]
			var size: Vector2i = info["size"]
			var touches: PackedStringArray = []
			if used.position.x <= 0:
				touches.append("left")
			if used.position.y <= 0:
				touches.append("top")
			if used.end.x >= size.x:
				touches.append("right")
			if used.end.y >= size.y:
				touches.append("bottom")
			if not touches.is_empty():
				_add(warnings, "GR052", slot, "alpha touches canvas edge: %s" % ", ".join(touches))
			_fit_bounds(manifest, assembler, part, vm, used)
	_fit_distal(manifest, assembler, part, vm)


func _pivot_abs(manifest: RigManifestScript, assembler: VisualAssemblerScript, part: VisualPartScript) -> Vector2:
	var a: Dictionary = assembler.attached.get(part.slot, {})
	var host: Node2D = a.get("host")
	if host != null and assembler.mirror_root != null:
		return assembler.mirror_root.to_local(host.global_position) + Vector2(manifest.center_axis_x, 0)
	var b: Dictionary = manifest.bone(part.attach_target)
	return b.get("pivot_absolute", Vector2.ZERO)


func _fit_distal(manifest: RigManifestScript, assembler: VisualAssemblerScript, part: VisualPartScript, vm: Dictionary) -> void:
	if not vm.has("distal_source") or not vm.has("distal_marker"):
		return
	var dm := str(vm["distal_marker"])
	if not manifest.has_marker(dm):
		_add(errors, "GR020", part.slot, "distal_marker %s unknown" % dm)
		return
	var pivot_abs := _pivot_abs(manifest, assembler, part)
	var off := VisualPartScript.source_to_logical_offset(vm, VisualPartScript.v2(vm["distal_source"]))
	var landed := pivot_abs + off
	var expected := manifest.marker(dm)
	var bone_vec := expected - pivot_abs
	var drift := landed.distance_to(expected)
	var angle_deg := 0.0
	var length_ratio := 0.0
	if off.length() > 0.0 and bone_vec.length() > 0.0:
		angle_deg = rad_to_deg(bone_vec.angle_to(off))
		length_ratio = off.length() / bone_vec.length()
	fit.append({
		"slot": part.slot, "distal_marker": dm, "expected": expected, "landed": landed,
		"drift_px": drift, "angle_mismatch_deg": angle_deg, "length_ratio": length_ratio,
	})
	if drift > 1.0:
		_add(warnings, "LAB01", part.slot, "distal joint lands %.1f px from %s (art axis %.1f deg off the bone)" % [drift, dm, angle_deg])


func _fit_bounds(manifest: RigManifestScript, assembler: VisualAssemblerScript, part: VisualPartScript, vm: Dictionary, used: Rect2i) -> void:
	var pivot_abs := _pivot_abs(manifest, assembler, part)
	var bottom := pivot_abs + VisualPartScript.source_to_logical_offset(vm, Vector2(0, used.end.y))
	if bottom.y > manifest.ground_y + 0.5:
		_add(warnings, "LAB02", part.slot, "lowest opaque pixel lands at y=%.1f, below ground_y=%.0f" % [bottom.y, manifest.ground_y])
	var left := pivot_abs + VisualPartScript.source_to_logical_offset(vm, Vector2(used.position.x, 0))
	var right := pivot_abs + VisualPartScript.source_to_logical_offset(vm, Vector2(used.end.x, 0))
	var top := pivot_abs + VisualPartScript.source_to_logical_offset(vm, Vector2(0, used.position.y))
	if left.x < 0 or right.x > manifest.canvas_size.x or top.y < 0:
		_add(warnings, "LAB03", part.slot, "part extends outside the logical canvas (x %.0f..%.0f, top %.0f)" % [left.x, right.x, top.y])


func _add(list: Array[Dictionary], code: String, slot: String, message: String) -> void:
	list.append({"code": code, "slot": slot, "message": message})


func to_text() -> String:
	var lines: PackedStringArray = []
	lines.append("ok: %s" % str(errors.is_empty()))
	lines.append("errors (%d):" % errors.size())
	for e in errors:
		lines.append("  %s [%s] %s" % [e["code"], e["slot"], e["message"]])
	lines.append("warnings (%d):" % warnings.size())
	for w in warnings:
		lines.append("  %s [%s] %s" % [w["code"], w["slot"], w["message"]])
	lines.append("fit diagnostics (distal joint of each part vs frozen marker):")
	for f in fit:
		lines.append("  %-17s -> %-10s drift %5.1f px  angle %6.1f deg  len x%.2f" % [f["slot"], f["distal_marker"], f["drift_px"], f["angle_mismatch_deg"], f["length_ratio"]])
	return "\n".join(lines)
