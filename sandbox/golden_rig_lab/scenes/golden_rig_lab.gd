extends Control
## Golden Rig Lab — P2.4B-0 gate (docs/05-visual/agent-contract/GOLDEN_RIG_LAB.md).
## Isolated dev bench. No gameplay state, no combat logic.
## Uses the production assembly path (RigManifest + VisualAssembler + VisualPart metadata).
## No pivot/anchor value lives in this file.

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const RigValidatorScript = preload("res://rig/rig_validator.gd")
const VisualPartScript = preload("res://rig/visual_part.gd")
const VisualAssemblerScript = preload("res://rig/visual_assembler.gd")

const APPEARANCE_SCENE_PATH := "res://scenes/vanguard_sword_shield_appearance.tscn"
const DEFAULT_ARMOR_SET := "res://metadata/armor_sets/armor_blackguard_01.armor_set.json"
const FIXTURE_NAME := "blackguard_p2_4b"
const SCREENSHOT_DIR := "res://screenshots"
const RENDER_SIZE := 1024            # SubViewport px (logical canvas x RENDER_SCALE)
const RENDER_SCALE := 2.0
const VIEW_LABELS := {"front_3q": "FRONT_3Q", "back_3q": "BACK_3Q"}
const FACING_LABELS := {"right": "Direita", "left": "Esquerda"}
## Only FRONT_3Q is enabled at gate P2.4B-0 (GOLDEN_RIG_LAB.md section 1).
const ENABLED_VIEWS := ["front_3q"]

enum Mode { GEOMETRY, ART, ZORDER }
const MODE_NAMES := ["Geometry", "Art", "Z-order"]
const MODE_BG := [Color(0.47, 0.47, 0.49), Color(0.10, 0.10, 0.12), Color(0.30, 0.30, 0.33)]

var appearance: Node2D
var manifest: RigManifestScript
var assembler: VisualAssemblerScript
var overlay: Node2D
var validator := RigValidatorScript.new()
var mode: int = Mode.GEOMETRY
var armor_visible := true

var sub_viewport: SubViewport
var vp_container: SubViewportContainer
var vp_host: Control
var stage: Node2D
var bg: ColorRect

var status_label: Label
var view_option: OptionButton
var facing_option: OptionButton
var mode_option: OptionButton
var toggles: Dictionary = {}   # key -> CheckButton
var slot_option: OptionButton
var spins: Dictionary = {}     # key -> SpinBox
var part_info: Label
var report_text: TextEdit
var _syncing := false


func _ready() -> void:
	_build_ui()
	_load_appearance()
	_apply_mode(Mode.GEOMETRY)
	_frame_full()
	_refresh_report()
	var args := OS.get_cmdline_user_args()
	var isolate_slot := ""
	for a in args:
		if a.begins_with("--isolate="):
			isolate_slot = a.substr(10)
	if "--capture" in args or isolate_slot != "":
		await get_tree().process_frame
		if isolate_slot != "":
			await export_isolated(isolate_slot)
		if "--capture" in args:
			await export_all()
		get_tree().quit()


# ---------------------------------------------------------------- UI construction

func _build_ui() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var hbox := HBoxContainer.new()
	hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(hbox)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(430, 0)
	hbox.add_child(panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)
	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(vbox)

	_label(vbox, "GOLDEN RIG LAB — VANGUARD_SWORD_SHIELD", 15)
	status_label = _label(vbox, "loading…", 11)
	status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_section(vbox, "View / facing / mode")
	view_option = OptionButton.new()
	for v in ["front_3q", "back_3q"]:
		view_option.add_item(VIEW_LABELS[v])
		view_option.set_item_metadata(view_option.item_count - 1, v)
		if not ENABLED_VIEWS.has(v):
			view_option.set_item_disabled(view_option.item_count - 1, true)
	view_option.item_selected.connect(_on_view_selected)
	_row(vbox, "View", view_option)
	facing_option = OptionButton.new()
	for f in ["right", "left"]:
		facing_option.add_item(FACING_LABELS[f])
		facing_option.set_item_metadata(facing_option.item_count - 1, f)
	facing_option.item_selected.connect(_on_facing_selected)
	_row(vbox, "Facing", facing_option)
	mode_option = OptionButton.new()
	for n in MODE_NAMES:
		mode_option.add_item(n)
	mode_option.item_selected.connect(_apply_mode)
	_row(vbox, "Mode", mode_option)

	_section(vbox, "Overlay toggles")
	for k in [["bones", "Bones"], ["pivots", "Pivots / joints"], ["sockets", "Sockets"], ["canvas", "Logical 512x512 canvas"], ["slots", "Slot names"], ["z", "Absolute z_index labels"]]:
		var cb := CheckButton.new()
		cb.text = k[1]
		cb.button_pressed = true
		cb.toggled.connect(func(_on): _apply_toggles())
		vbox.add_child(cb)
		toggles[k[0]] = cb
	var armor_cb := CheckButton.new()
	armor_cb.text = "Armor parts visible (off = empty shared rig)"
	armor_cb.button_pressed = true
	armor_cb.toggled.connect(_set_armor_visible)
	vbox.add_child(armor_cb)
	toggles["armor"] = armor_cb
	var iso_cb := CheckButton.new()
	iso_cb.text = "Isolate selected slot (hide the other armor parts)"
	iso_cb.button_pressed = false
	iso_cb.toggled.connect(func(on: bool): _apply_isolation(on))
	vbox.add_child(iso_cb)
	toggles["isolate"] = iso_cb

	_section(vbox, "Armor set")
	var reload_btn := Button.new()
	reload_btn.text = "Reload armor set + metadata from disk"
	reload_btn.pressed.connect(_reload_armor_set)
	vbox.add_child(reload_btn)

	_section(vbox, "Slot metadata inspector (pivot / canvas_offset / scale / z_index)")
	slot_option = OptionButton.new()
	slot_option.item_selected.connect(func(_i): _sync_inspector())
	_row(vbox, "Slot", slot_option)
	part_info = _label(vbox, "", 10)
	part_info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var grid := GridContainer.new()
	grid.columns = 4
	vbox.add_child(grid)
	_spin(grid, "pivot_x", "pivot x", 0, 8192, 1)
	_spin(grid, "pivot_y", "pivot y", 0, 8192, 1)
	_spin(grid, "offset_x", "offset x", -8192, 8192, 1)
	_spin(grid, "offset_y", "offset y", -8192, 8192, 1)
	_spin(grid, "scale", "scale", 0.0001, 8.0, 0.0001)
	_spin(grid, "z", "z_index", -1000, 1000, 1)
	var save_row := HBoxContainer.new()
	vbox.add_child(save_row)
	var save_btn := Button.new()
	save_btn.text = "Save slot metadata"
	save_btn.pressed.connect(_save_slot)
	save_row.add_child(save_btn)
	var save_all_btn := Button.new()
	save_all_btn.text = "Save all"
	save_all_btn.pressed.connect(_save_all)
	save_row.add_child(save_all_btn)

	_section(vbox, "Export (res://screenshots)")
	var exp_row := HBoxContainer.new()
	vbox.add_child(exp_row)
	_button(exp_row, "Clean composite", func(): await _export_single(Mode.ART, true))
	_button(exp_row, "Debug overlay", func(): await _export_single(Mode.GEOMETRY, false))
	_button(exp_row, "Z-order", func(): await _export_single(Mode.ZORDER, false))
	var exp_row2 := HBoxContainer.new()
	vbox.add_child(exp_row2)
	_button(exp_row2, "Joint closeups", func(): await _export_closeups())
	_button(exp_row2, "EXPORT ALL (P2.4B-0 set)", func(): await export_all())
	var frame_row := HBoxContainer.new()
	vbox.add_child(frame_row)
	_button(frame_row, "Frame: full canvas", _frame_full)
	for c in _closeups():
		_button(frame_row, c["short"], func(): _frame_closeup(c["center"], c["zoom"]))

	_section(vbox, "Validation report / current asset IDs")
	report_text = TextEdit.new()
	report_text.editable = false
	report_text.custom_minimum_size = Vector2(0, 330)
	report_text.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	vbox.add_child(report_text)

	vp_host = Control.new()
	vp_host.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vp_host.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vp_host.clip_contents = true
	hbox.add_child(vp_host)
	vp_container = SubViewportContainer.new()
	vp_container.stretch = false
	vp_container.size = Vector2(RENDER_SIZE, RENDER_SIZE)
	vp_host.add_child(vp_container)
	sub_viewport = SubViewport.new()
	sub_viewport.size = Vector2i(RENDER_SIZE, RENDER_SIZE)
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.transparent_bg = false
	vp_container.add_child(sub_viewport)
	bg = ColorRect.new()
	bg.size = Vector2(RENDER_SIZE, RENDER_SIZE)
	bg.color = MODE_BG[Mode.GEOMETRY]
	sub_viewport.add_child(bg)
	stage = Node2D.new()
	stage.name = "Stage"
	sub_viewport.add_child(stage)
	vp_host.resized.connect(_fit_viewport)
	_fit_viewport()


func _label(parent: Node, text: String, size: int) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	parent.add_child(l)
	return l


func _section(parent: Node, text: String) -> void:
	var sep := HSeparator.new()
	parent.add_child(sep)
	var l := _label(parent, text, 12)
	l.modulate = Color(0.8, 0.9, 1.0)


func _row(parent: Node, caption: String, control: Control) -> void:
	var h := HBoxContainer.new()
	parent.add_child(h)
	var l := Label.new()
	l.text = caption
	l.custom_minimum_size = Vector2(70, 0)
	h.add_child(l)
	control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	h.add_child(control)


func _spin(parent: Node, key: String, caption: String, lo: float, hi: float, step: float) -> void:
	var l := Label.new()
	l.text = caption
	parent.add_child(l)
	var s := SpinBox.new()
	s.min_value = lo
	s.max_value = hi
	s.step = step
	s.allow_greater = true
	s.allow_lesser = true
	s.custom_minimum_size = Vector2(110, 0)
	s.value_changed.connect(func(_v): _on_inspector_changed())
	parent.add_child(s)
	spins[key] = s


func _button(parent: Node, text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.pressed.connect(cb)
	parent.add_child(b)


func _fit_viewport() -> void:
	if vp_host == null:
		return
	var avail := vp_host.size
	var f := minf(avail.x / RENDER_SIZE, avail.y / RENDER_SIZE)
	f = minf(f, 1.0)
	if f <= 0.0:
		return
	vp_container.scale = Vector2(f, f)
	vp_container.position = (avail - Vector2(RENDER_SIZE, RENDER_SIZE) * f) * 0.5


# ---------------------------------------------------------------- appearance / assembly

func _load_appearance() -> void:
	if not ResourceLoader.exists(APPEARANCE_SCENE_PATH):
		status_label.text = "Appearance scene missing. Run: godot --headless -s tools/generate_appearance_scene.gd"
		return
	var packed: PackedScene = load(APPEARANCE_SCENE_PATH)
	appearance = packed.instantiate()
	stage.add_child(appearance)
	manifest = appearance.manifest
	assembler = appearance.assembler
	overlay = appearance.debug_overlay
	assembler.parts_changed.connect(_on_parts_changed)
	_reload_armor_set()
	_update_status()


func _reload_armor_set() -> void:
	if assembler == null:
		return
	assembler.load_armor_set(DEFAULT_ARMOR_SET)
	assembler.apply(assembler.current_view)
	assembler.set_facing(assembler.current_facing)
	_set_armor_visible(armor_visible)
	_populate_slots()
	_refresh_report()


func _update_status() -> void:
	if manifest == null:
		return
	var ok: bool = appearance.rig_is_verified()
	status_label.text = "rig %s (%s) — canvas %dx%d, axis x=%d, ground y=%d — scene verify: %s" % [
		manifest.rig_id, manifest.status, int(manifest.canvas_size.x), int(manifest.canvas_size.y),
		int(manifest.center_axis_x), int(manifest.ground_y), "OK (GR022/GR023 clean)" if ok else "%d ERROR(S)" % appearance.verify_errors.size()]


func _populate_slots() -> void:
	slot_option.clear()
	for slot in assembler.attached_slots():
		slot_option.add_item(slot)
	if slot_option.item_count > 0:
		slot_option.select(0)
	_sync_inspector()


func _current_slot() -> String:
	if slot_option.item_count == 0 or slot_option.selected < 0:
		return ""
	return slot_option.get_item_text(slot_option.selected)


func _current_view_meta() -> Dictionary:
	var slot := _current_slot()
	if slot == "" or not assembler.parts.has(slot):
		return {}
	var part: VisualPartScript = assembler.parts[slot]
	return part.view(assembler.current_view)


func _sync_inspector() -> void:
	var vm := _current_view_meta()
	if vm.is_empty():
		return
	_syncing = true
	var pivot := VisualPartScript.v2(vm.get("pivot_source"))
	var off := VisualPartScript.v2(vm.get("canvas_offset"))
	spins["pivot_x"].value = pivot.x
	spins["pivot_y"].value = pivot.y
	spins["offset_x"].value = off.x
	spins["offset_y"].value = off.y
	spins["scale"].value = float(vm.get("scale_to_logical", 1.0))
	spins["z"].value = int(vm.get("z_index", 0))
	_syncing = false
	var part: VisualPartScript = assembler.parts[_current_slot()]
	part_info.text = "%s  ->  bone %s / sprite %s  |  tex %s  |  src %s  |  pivot marker %s" % [
		part.part_id, part.attach_target, part.sprite_node, str(vm.get("texture", "")).get_file(),
		str(vm.get("source_size")), str(vm.get("pivot_marker", "-"))]


func _on_inspector_changed() -> void:
	if _syncing:
		return
	var vm := _current_view_meta()
	if vm.is_empty():
		return
	vm["pivot_source"] = [spins["pivot_x"].value, spins["pivot_y"].value]
	vm["canvas_offset"] = [spins["offset_x"].value, spins["offset_y"].value]
	vm["scale_to_logical"] = spins["scale"].value
	vm["z_index"] = int(spins["z"].value)
	assembler.reapply(_current_slot())
	_refresh_report()


func _save_slot() -> void:
	var slot := _current_slot()
	if slot == "":
		return
	var part: VisualPartScript = assembler.parts[slot]
	var err := part.save()
	status_label.text = "saved %s -> %s (%s)" % [slot, part.path, error_string(err)]


func _save_all() -> void:
	var n := 0
	for slot in assembler.parts:
		if assembler.parts[slot].save() == OK:
			n += 1
	status_label.text = "saved %d part metadata files" % n


func _on_parts_changed() -> void:
	if overlay != null:
		overlay.queue_redraw()


func _on_view_selected(idx: int) -> void:
	var v: String = view_option.get_item_metadata(idx)
	if not ENABLED_VIEWS.has(v):
		view_option.select(0)
		status_label.text = "%s is not enabled at gate P2.4B-0 (GOLDEN_RIG_LAB.md section 1)" % VIEW_LABELS[v]
		return
	assembler.set_view(v)
	_populate_slots()
	_update_view_label()
	_refresh_report()


func _on_facing_selected(idx: int) -> void:
	var f: String = facing_option.get_item_metadata(idx)
	if not assembler.set_facing(f):
		facing_option.select(0)
		status_label.text = "Facing %s refused: mirror only when every part is mirror_safe (scene contract). Parts stay canonical (right)." % FACING_LABELS[f]
	_update_view_label()
	_refresh_report()


func _update_view_label() -> void:
	if overlay == null:
		return
	overlay.view_label = "%s / %s   set %s   fixture %s" % [VIEW_LABELS[assembler.current_view], assembler.current_facing.to_upper(), str(assembler.armor_set.get("armor_set_id", "-")), FIXTURE_NAME]
	overlay.queue_redraw()


func _set_armor_visible(v: bool) -> void:
	armor_visible = v
	if toggles.has("armor") and toggles["armor"].button_pressed != v:
		toggles["armor"].set_pressed_no_signal(v)
	if assembler != null:
		assembler.set_armor_visible(v)
	if v and toggles.has("isolate") and toggles["isolate"].button_pressed:
		_apply_isolation(true)


## Review aid: show only one slot's sprite (all others hidden). Pure visibility; no transform is touched.
func _apply_isolation(on: bool, slot: String = "") -> void:
	if assembler == null:
		return
	if slot == "":
		slot = _current_slot()
	for s in assembler.attached:
		assembler.attached[s]["sprite"].visible = armor_visible and (not on or s == slot)
	assembler.parts_changed.emit()


## Exports full-frame geometry + art renders with only `slot` visible: <fixture>__<view>__<facing>__isolate_<slot>__<mode>.png
func export_isolated(slot: String) -> PackedStringArray:
	var files: PackedStringArray = []
	if assembler == null or not assembler.attached.has(slot):
		status_label.text = "isolate: slot %s not attached" % slot
		return files
	var saved_mode := mode
	_frame_full()
	_set_armor_visible(true)
	_apply_isolation(true, slot)
	_apply_mode(Mode.GEOMETRY)
	files.append(await _capture_viewport(_shot_path("isolate_%s__geometry" % slot)))
	_apply_mode(Mode.ART)
	files.append(await _capture_viewport(_shot_path("isolate_%s__art" % slot)))
	_apply_isolation(false, slot)
	_apply_mode(saved_mode)
	for p in files:
		print("[lab] exported ", p)
	return files


# ---------------------------------------------------------------- modes / overlay

func _apply_mode(m: int) -> void:
	mode = m
	if mode_option.selected != m:
		mode_option.select(m)
	bg.color = MODE_BG[m]
	var defaults := {
		Mode.GEOMETRY: {"bones": true, "pivots": true, "sockets": true, "canvas": true, "slots": true, "z": true},
		Mode.ART: {"bones": false, "pivots": false, "sockets": false, "canvas": false, "slots": false, "z": false},
		Mode.ZORDER: {"bones": false, "pivots": false, "sockets": false, "canvas": true, "slots": true, "z": true},
	}
	for k in defaults[m]:
		toggles[k].set_pressed_no_signal(defaults[m][k])
	_apply_toggles()


func _apply_toggles() -> void:
	if overlay == null:
		return
	overlay.show_bones = toggles["bones"].button_pressed
	overlay.show_pivots = toggles["pivots"].button_pressed
	overlay.show_sockets = toggles["sockets"].button_pressed
	overlay.show_canvas = toggles["canvas"].button_pressed
	overlay.show_slot_labels = toggles["slots"].button_pressed
	overlay.show_z_labels = toggles["z"].button_pressed
	overlay.labels_at_sprite_center = (mode == Mode.ZORDER)
	overlay.visible = overlay.show_bones or overlay.show_pivots or overlay.show_sockets or overlay.show_canvas or overlay.show_slot_labels or overlay.show_z_labels
	_update_view_label()


func _frame_full() -> void:
	stage.scale = Vector2(RENDER_SCALE, RENDER_SCALE)
	stage.position = Vector2.ZERO
	if overlay != null:
		overlay.pixel_scale = 1.0 / RENDER_SCALE
		overlay.queue_redraw()


func _frame_closeup(center: Vector2, zoom: float) -> void:
	stage.scale = Vector2(zoom, zoom)
	stage.position = Vector2(RENDER_SIZE, RENDER_SIZE) * 0.5 - center * zoom
	if overlay != null:
		overlay.pixel_scale = 1.0 / zoom
		overlay.queue_redraw()


## Closeup framings are derived from the frozen markers, never from artwork.
func _closeups() -> Array:
	if manifest == null:
		return []
	var m := manifest
	return [
		{"name": "closeup_shoulder_elbow_l", "short": "L arm", "center": (m.marker("SHOULDER_L") + m.marker("ELBOW_L")) * 0.5, "zoom": 6.0},
		{"name": "closeup_shoulder_elbow_r", "short": "R arm", "center": (m.marker("SHOULDER_R") + m.marker("ELBOW_R")) * 0.5, "zoom": 6.0},
		{"name": "closeup_hip_knee_boot_l", "short": "L leg", "center": (m.marker("HIP_L") + m.marker("FOOT_L")) * 0.5, "zoom": 4.0},
		{"name": "closeup_hip_knee_boot_r", "short": "R leg", "center": (m.marker("HIP_R") + m.marker("FOOT_R")) * 0.5, "zoom": 4.0},
		{"name": "closeup_waist_tabard", "short": "Waist", "center": m.marker("HIP"), "zoom": 4.0},
	]


# ---------------------------------------------------------------- report

func _refresh_report() -> void:
	if manifest == null or assembler == null:
		return
	validator.run(manifest, appearance.skeleton, assembler)
	var lines: PackedStringArray = []
	lines.append("view=%s facing=%s mode=%s" % [assembler.current_view, assembler.current_facing, MODE_NAMES[mode]])
	lines.append("armor_set=%s status=%s" % [str(assembler.armor_set.get("armor_set_id", "-")), str(assembler.armor_set.get("status", "-"))])
	lines.append("current asset IDs:")
	for slot in assembler.attached_slots():
		var a: Dictionary = assembler.attached[slot]
		var part: VisualPartScript = a["part"]
		var vm: Dictionary = part.view(assembler.current_view)
		lines.append("  %-17s %-32s z=%-3d pivot=%s scale=%.4f" % [slot, part.part_id, a["sprite"].z_index, str(vm.get("pivot_source")), float(vm.get("scale_to_logical", 1.0))])
	lines.append("")
	lines.append(validator.to_text())
	report_text.text = "\n".join(lines)


func report_as_text() -> String:
	return report_text.text


## Machine-readable validation snapshot (used by tools/compare_validation.py for before/after).
func validation_as_dict() -> Dictionary:
	var slots := {}
	for slot in assembler.attached_slots():
		var a: Dictionary = assembler.attached[slot]
		var part: VisualPartScript = a["part"]
		var vm: Dictionary = part.view(assembler.current_view)
		slots[slot] = {
			"part_id": part.part_id,
			"texture": str(vm.get("texture", "")).get_file(),
			"source_size": vm.get("source_size"),
			"pivot_source": vm.get("pivot_source"),
			"canvas_offset": vm.get("canvas_offset"),
			"scale_to_logical": vm.get("scale_to_logical"),
			"z_index": a["sprite"].z_index,
			"errors": [],
			"warnings": [],
			"fit": null,
		}
	for e in validator.errors:
		if slots.has(e["slot"]):
			slots[e["slot"]]["errors"].append("%s %s" % [e["code"], e["message"]])
	for w in validator.warnings:
		if slots.has(w["slot"]):
			slots[w["slot"]]["warnings"].append("%s %s" % [w["code"], w["message"]])
	for fd in validator.fit:
		if slots.has(fd["slot"]):
			slots[fd["slot"]]["fit"] = {
				"distal_marker": fd["distal_marker"],
				"expected": [fd["expected"].x, fd["expected"].y],
				"landed": [fd["landed"].x, fd["landed"].y],
				"drift_px": fd["drift_px"],
				"angle_mismatch_deg": fd["angle_mismatch_deg"],
				"length_ratio": fd["length_ratio"],
			}
	return {
		"fixture": FIXTURE_NAME,
		"armor_set": str(assembler.armor_set.get("armor_set_id", "")),
		"view": assembler.current_view,
		"facing": assembler.current_facing,
		"rig_id": manifest.rig_id,
		"rig_status": manifest.status,
		"rig_verified": appearance.rig_is_verified(),
		"ok": validator.errors.is_empty(),
		"error_count": validator.errors.size(),
		"warning_count": validator.warnings.size(),
		"global_errors": validator.errors.filter(func(e): return e["slot"] == "").map(func(e): return "%s %s" % [e["code"], e["message"]]),
		"slots": slots,
	}


# ---------------------------------------------------------------- export

func _shot_path(suffix: String) -> String:
	var view_tag: String = VIEW_LABELS[assembler.current_view].to_lower().replace("_", "")
	return "%s/%s__%s__%s__%s.png" % [SCREENSHOT_DIR, FIXTURE_NAME, view_tag, assembler.current_facing, suffix]


func _ensure_dir() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SCREENSHOT_DIR))


func _capture_viewport(path: String, also_1x: bool = false) -> String:
	_ensure_dir()
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var img: Image = sub_viewport.get_texture().get_image()
	img.save_png(ProjectSettings.globalize_path(path))
	if also_1x:
		var one := img.duplicate() as Image
		one.resize(int(manifest.canvas_size.x), int(manifest.canvas_size.y), Image.INTERPOLATE_LANCZOS)
		one.save_png(ProjectSettings.globalize_path(path.replace(".png", "__1x.png")))
	return path


func _capture_window(path: String) -> String:
	_ensure_dir()
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var img: Image = get_viewport().get_texture().get_image()
	img.save_png(ProjectSettings.globalize_path(path))
	return path


func _export_single(m: int, also_1x: bool) -> String:
	var saved_mode := mode
	_apply_mode(m)
	var suffix: String = ["geometry", "art", "zorder"][m]
	var p: String = await _capture_viewport(_shot_path(suffix), also_1x)
	_apply_mode(saved_mode)
	status_label.text = "exported %s" % p
	return p


func _export_closeups() -> PackedStringArray:
	var files: PackedStringArray = []
	var saved_mode := mode
	for c in _closeups():
		_frame_closeup(c["center"], c["zoom"])
		_apply_mode(Mode.GEOMETRY)
		files.append(await _capture_viewport(_shot_path("%s__geometry" % c["name"])))
		_apply_mode(Mode.ART)
		files.append(await _capture_viewport(_shot_path("%s__art" % c["name"])))
	_frame_full()
	_apply_mode(saved_mode)
	status_label.text = "exported %d closeups" % files.size()
	return files


## Produces the full P2.4B-0 screenshot set (GOLDEN_RIG_LAB.md section 7) + validation report.
func export_all() -> PackedStringArray:
	var files: PackedStringArray = []
	if assembler == null:
		return files
	var saved_mode := mode
	var saved_armor := armor_visible
	_frame_full()
	_apply_mode(Mode.GEOMETRY)
	_set_armor_visible(true)
	files.append(await _capture_window(_shot_path("lab_open")))
	_set_armor_visible(false)
	files.append(await _capture_viewport(_shot_path("rig_empty__geometry")))
	_set_armor_visible(true)
	files.append(await _capture_viewport(_shot_path("geometry")))
	_apply_mode(Mode.ART)
	files.append(await _capture_viewport(_shot_path("art"), true))
	_apply_mode(Mode.ZORDER)
	files.append(await _capture_viewport(_shot_path("zorder")))
	files.append_array(await _export_closeups())
	_apply_mode(saved_mode)
	_set_armor_visible(saved_armor)
	_refresh_report()
	var report_path := _shot_path("validation").replace(".png", ".txt")
	var f := FileAccess.open(report_path, FileAccess.WRITE)
	if f != null:
		f.store_string(report_as_text() + "\n")
		files.append(report_path)
	var json_path := _shot_path("validation").replace(".png", ".json")
	var jf := FileAccess.open(json_path, FileAccess.WRITE)
	if jf != null:
		jf.store_string(JSON.stringify(validation_as_dict(), "\t") + "\n")
		files.append(json_path)
	status_label.text = "exported %d files to %s" % [files.size(), SCREENSHOT_DIR]
	for p in files:
		print("[lab] exported ", p)
	return files
