class_name VisualPart
extends RefCounted
## One modular visual part (e.g. armor_blackguard_01.torso) and its per-view placement metadata.
## The sprite placement invariant (GODOT_SCENE_CONTRACT) lives ONLY in `placement()`.

var path: String = ""
var data: Dictionary = {}
var part_id: String = ""
var armor_set_id: String = ""
var slot: String = ""
var attach_kind: String = "bone"
var attach_target: String = ""
var sprite_node: String = ""
var z_lane: String = ""
var mirror_safe: bool = false
var views: Dictionary = {}   # view -> Dictionary (edited live by the Lab inspector, saved with save())
var errors: PackedStringArray = []


static func load_from(p: String) -> VisualPart:
	var vp := VisualPart.new()
	vp.path = p
	if not FileAccess.file_exists(p):
		vp.errors.append("GR003 part metadata not found: %s" % p)
		return vp
	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(p)) != OK:
		vp.errors.append("GR001 part JSON parse error in %s: %s" % [p, json.get_error_message()])
		return vp
	vp.data = json.data
	vp.part_id = str(vp.data.get("part_id", ""))
	vp.armor_set_id = str(vp.data.get("armor_set_id", ""))
	vp.slot = str(vp.data.get("slot", ""))
	var att: Dictionary = vp.data.get("attachment", {})
	vp.attach_kind = str(att.get("kind", "bone"))
	vp.attach_target = str(att.get("target", ""))
	vp.sprite_node = str(att.get("sprite_node", ""))
	vp.z_lane = str(vp.data.get("z_lane", ""))
	vp.mirror_safe = bool(vp.data.get("mirror_safe", false))
	vp.views = vp.data.get("views", {})
	return vp


static func v2(a, fallback := Vector2.ZERO) -> Vector2:
	if typeof(a) == TYPE_ARRAY and a.size() >= 2:
		return Vector2(float(a[0]), float(a[1]))
	return fallback


func has_view(view: String) -> bool:
	return views.has(view)


func view(view: String) -> Dictionary:
	return views.get(view, {})


## Sprite placement invariant.
## For a full-canvas normalized 512x512 texture: sprite_local_position = (256,256) - pivot_source.
## Generalized for raw candidates (scale normalization) and trimmed textures (canvas_offset):
##   pivot_texture = pivot_source - canvas_offset
##   position      = (texture_size/2 - pivot_texture) * scale
static func placement(vm: Dictionary) -> Dictionary:
	var source_size := v2(vm.get("source_size"), Vector2(512, 512))
	var canvas_offset := v2(vm.get("canvas_offset"), Vector2.ZERO)
	var pivot := v2(vm.get("pivot_source"), source_size * 0.5)
	var s := float(vm.get("scale_to_logical", 1.0))
	var pivot_tex := pivot - canvas_offset
	return {
		"position": (source_size * 0.5 - pivot_tex) * s,
		"scale": Vector2(s, s),
	}


## Maps a point given in source-canvas pixels to logical px relative to the part pivot.
static func source_to_logical_offset(vm: Dictionary, source_point: Vector2) -> Vector2:
	var pivot := v2(vm.get("pivot_source"))
	var s := float(vm.get("scale_to_logical", 1.0))
	return (source_point - pivot) * s


func save() -> Error:
	data["views"] = views
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return FileAccess.get_open_error()
	f.store_string(JSON.stringify(data, "\t") + "\n")
	return OK
