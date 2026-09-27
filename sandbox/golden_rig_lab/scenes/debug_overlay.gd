extends Node2D
## Dev-only overlay (GODOT_SCENE_CONTRACT: DebugOverlay).
## Draws: 512 canvas bounds, center axis, ground line, all bones, primary joints, secondary pivots,
## sockets, current view, slot names and absolute z-index labels.
## Reads everything from the manifest and the live scene nodes. Never modifies them.

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const VisualAssemblerScript = preload("res://rig/visual_assembler.gd")

const COL_CANVAS := Color(1, 1, 1, 0.6)
const COL_AXIS := Color(0.3, 0.9, 1.0, 0.85)
const COL_GROUND := Color(1.0, 0.6, 0.2, 0.95)
const COL_BONE := Color(1.0, 0.95, 0.2, 1.0)
const COL_JOINT := Color(1.0, 0.2, 0.2, 1.0)
const COL_SECONDARY := Color(1.0, 0.35, 1.0, 1.0)
const COL_SOCKET := Color(0.2, 1.0, 0.4, 1.0)
const COL_TEXT := Color(1, 1, 1, 1)
const COL_SHADOW := Color(0, 0, 0, 0.85)

var manifest: RigManifestScript
var skeleton: Skeleton2D
var assembler: VisualAssemblerScript
var mirror_root: Node2D

var show_canvas := true
var show_bones := true
var show_pivots := true
var show_sockets := true
var show_slot_labels := true
var show_z_labels := true
var labels_at_sprite_center := false
var view_label := ""
## Logical px per screen px (1 / stage zoom). Keeps strokes and text a constant screen size.
var pixel_scale := 0.5


func setup(m: RigManifestScript, sk: Skeleton2D, asm: VisualAssemblerScript, mr: Node2D) -> void:
	manifest = m
	skeleton = sk
	assembler = asm
	mirror_root = mr
	z_as_relative = false
	z_index = 4000
	if assembler != null and not assembler.parts_changed.is_connected(queue_redraw):
		assembler.parts_changed.connect(queue_redraw)
	queue_redraw()


func _abs_to_local(v: Vector2) -> Vector2:
	# Manifest markers are absolute logical coords; bones live under MirrorRoot(center_axis_x, 0).
	return to_local(mirror_root.to_global(v - Vector2(manifest.center_axis_x, 0)))


func _text(font: Font, pos: Vector2, s: String, color: Color) -> void:
	var fs := maxi(int(round(15.0 * pixel_scale)), 2)
	draw_string(font, pos + Vector2(1, 1) * pixel_scale, s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, COL_SHADOW)
	draw_string(font, pos, s, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, color)


func _draw() -> void:
	if manifest == null or skeleton == null:
		return
	var font: Font = ThemeDB.fallback_font
	var w := 1.5 * pixel_scale
	if show_canvas:
		draw_rect(Rect2(Vector2.ZERO, manifest.canvas_size), COL_CANVAS, false, w)
		draw_line(Vector2(manifest.center_axis_x, 0), Vector2(manifest.center_axis_x, manifest.canvas_size.y), COL_AXIS, w)
		draw_line(Vector2(0, manifest.ground_y), Vector2(manifest.canvas_size.x, manifest.ground_y), COL_GROUND, w)
		_text(font, Vector2(3, 14 * pixel_scale + 2), "canvas %dx%d  axis x=%d  ground y=%d" % [int(manifest.canvas_size.x), int(manifest.canvas_size.y), int(manifest.center_axis_x), int(manifest.ground_y)], COL_CANVAS)
		_text(font, Vector2(3, manifest.ground_y - 3 * pixel_scale), "ground", COL_GROUND)
	if show_bones:
		for b in manifest.bones:
			var node := skeleton.find_child(b["id"], true, false) as Node2D
			if node == null:
				continue
			var p0 := to_local(node.global_position)
			var end_local: Vector2 = manifest.bone_end_local(b["id"])
			if end_local != Vector2.ZERO:
				var p1 := to_local(node.to_global(end_local))
				draw_line(p0, p1, COL_BONE, 1.5 * w)
				draw_circle(p1, 1.5 * w, COL_BONE)
			draw_circle(p0, 2.5 * w, COL_BONE)
			if show_slot_labels:
				var label_w := font.get_string_size(b["id"], HORIZONTAL_ALIGNMENT_LEFT, -1, maxi(int(round(15.0 * pixel_scale)), 2)).x
				_text(font, p0 + Vector2(-label_w - 6 * pixel_scale, -4 * pixel_scale), b["id"], COL_BONE)
	if show_pivots:
		for name in manifest.primary_markers:
			var p := _abs_to_local(manifest.primary_markers[name])
			draw_circle(p, 2.5 * w, COL_JOINT)
			draw_arc(p, 5.0 * w, 0.0, TAU, 24, COL_JOINT, w)
			_text(font, p + Vector2(6, -6) * pixel_scale, name, COL_JOINT)
		for name in manifest.secondary_pivots:
			var p := _abs_to_local(manifest.secondary_pivots[name])
			draw_circle(p, 2.0 * w, COL_SECONDARY)
			draw_arc(p, 4.0 * w, 0.0, TAU, 20, COL_SECONDARY, w)
			_text(font, p + Vector2(6, 12) * pixel_scale, name, COL_SECONDARY)
	if show_sockets:
		for s in manifest.sockets:
			var node := skeleton.find_child(s["id"], true, false) as Node2D
			if node == null:
				continue
			var p := to_local(node.global_position)
			draw_rect(Rect2(p - Vector2(3, 3) * w, Vector2(6, 6) * w), COL_SOCKET, false, w)
			_text(font, p + Vector2(6, 4) * pixel_scale, s["id"], COL_SOCKET)
	if (show_slot_labels or show_z_labels) and assembler != null:
		var i := 0
		for slot in assembler.attached_slots():
			var a: Dictionary = assembler.attached[slot]
			var sprite: Sprite2D = a["sprite"]
			if not sprite.visible:
				continue
			var host: Node2D = a["host"]
			var p := to_local(sprite.global_position) if labels_at_sprite_center else to_local(host.global_position)
			var txt := ""
			if show_slot_labels:
				txt = slot
			if show_z_labels:
				txt += (" " if txt != "" else "") + "z=%d" % sprite.z_index
			var stagger := 0.0 if labels_at_sprite_center else float(i % 3) * 14.0
			_text(font, p + Vector2(8, 18 + stagger) * pixel_scale, txt, COL_TEXT)
			i += 1
	if view_label != "":
		_text(font, Vector2(3, manifest.canvas_size.y - 6 * pixel_scale), view_label, COL_TEXT)
