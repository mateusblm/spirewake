class_name VisualAssembler
extends Node
## Production-path assembler: attaches VisualParts to the frozen skeleton using ONLY part metadata.
## It never moves bones, never adds nodes to the skeleton and never infers pivots from textures.

signal parts_changed

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const VisualPartScript = preload("res://rig/visual_part.gd")

var manifest: RigManifestScript
var skeleton: Skeleton2D
var mirror_root: Node2D
var current_view: String = "front_3q"
var current_facing: String = "right"
var armor_set: Dictionary = {}
var parts: Dictionary = {}      # slot -> VisualPart
var attached: Dictionary = {}   # slot -> {"sprite": Sprite2D, "host": Node2D, "part": VisualPart}
var problems: Array[Dictionary] = []   # {"code", "slot", "message"}


func setup(p_manifest: RigManifestScript, p_skeleton: Skeleton2D, p_mirror_root: Node2D) -> void:
	manifest = p_manifest
	skeleton = p_skeleton
	mirror_root = p_mirror_root


func load_armor_set(path: String) -> Dictionary:
	problems.clear()
	if not FileAccess.file_exists(path):
		_problem("GR003", "", "armor set file not found: %s" % path)
		return {}
	var json := JSON.new()
	if json.parse(FileAccess.get_file_as_string(path)) != OK:
		_problem("GR001", "", "armor set JSON error: %s" % json.get_error_message())
		return {}
	armor_set = json.data
	parts.clear()
	var declared: Dictionary = armor_set.get("parts", {})
	for slot in declared:
		var vp: VisualPartScript = VisualPartScript.load_from(str(declared[slot]))
		for e in vp.errors:
			_problem(e.substr(0, 5), slot, e)
		if vp.armor_set_id != str(armor_set.get("armor_set_id", "")):
			_problem("GR031", slot, "part %s belongs to set %s, not %s" % [vp.part_id, vp.armor_set_id, armor_set.get("armor_set_id")])
		parts[slot] = vp
	for m in armor_set.get("mandatory_slots", []):
		if not parts.has(m):
			_problem("GR030", m, "armor set missing mandatory piece %s" % m)
	return armor_set


func apply(view: String = current_view) -> void:
	current_view = view
	clear_all()
	for slot in parts:
		attach_part(parts[slot], view)
	parts_changed.emit()


func attach_part(part: VisualPartScript, view: String) -> bool:
	var slot: String = part.slot
	if part.attach_kind != "bone" and part.attach_kind != "socket":
		_problem("GR020", slot, "unknown attachment kind %s" % part.attach_kind)
		return false
	if part.attach_kind == "bone" and not manifest.has_bone(part.attach_target):
		_problem("GR020", slot, "unknown bone %s" % part.attach_target)
		return false
	if part.attach_kind == "socket" and not manifest.has_socket(part.attach_target):
		_problem("GR020", slot, "unknown socket %s" % part.attach_target)
		return false
	var host := skeleton.find_child(part.attach_target, true, false) as Node2D
	if host == null:
		_problem("GR022", slot, "attachment target %s not present in scene" % part.attach_target)
		return false
	var sprite := host.get_node_or_null(part.sprite_node) as Sprite2D
	if sprite == null:
		_problem("GR022", slot, "sprite node %s is not a child of %s (scene contract)" % [part.sprite_node, part.attach_target])
		return false
	if not part.has_view(view):
		_problem("GR010", slot, "view %s missing for part %s" % [view, part.part_id])
		sprite.texture = null
		sprite.visible = false
		return false
	var vm: Dictionary = part.view(view)
	var tex_path := str(vm.get("texture", ""))
	var tex: Texture2D = null
	if ResourceLoader.exists(tex_path):
		tex = load(tex_path)
	if tex == null:
		_problem("GR003", slot, "texture missing: %s" % tex_path)
		return false
	_apply_to_sprite(sprite, vm, tex)
	attached[slot] = {"sprite": sprite, "host": host, "part": part}
	return true


func _apply_to_sprite(sprite: Sprite2D, vm: Dictionary, tex: Texture2D) -> void:
	var pl: Dictionary = VisualPartScript.placement(vm)
	sprite.texture = tex
	sprite.centered = true
	sprite.offset = Vector2.ZERO
	sprite.rotation = 0.0
	sprite.position = pl["position"]
	sprite.scale = pl["scale"]
	sprite.z_as_relative = false
	sprite.z_index = int(vm.get("z_index", 0))
	sprite.visible = true


## Re-applies a slot after its metadata dictionary was edited in place (Lab inspector).
func reapply(slot: String) -> void:
	if not attached.has(slot):
		return
	var a: Dictionary = attached[slot]
	var part: VisualPartScript = a["part"]
	var vm: Dictionary = part.view(current_view)
	_apply_to_sprite(a["sprite"], vm, a["sprite"].texture)
	parts_changed.emit()


func set_view(view: String) -> void:
	if not manifest.authored_views.has(view):
		_problem("GR010", "", "view %s is not an authored view" % view)
		return
	apply(view)


## Mirror policy: mirror only when every attached part is mirror_safe. Returns true if applied.
func set_facing(facing: String) -> bool:
	if not manifest.horizontal_facing.has(facing):
		return false
	var wants_mirror: bool = manifest.mirror_x_for_facing(facing)
	if wants_mirror:
		for slot in attached:
			var part: VisualPartScript = attached[slot]["part"]
			if not part.mirror_safe:
				_problem("MIRROR", slot, "facing %s refused: part %s is not mirror_safe" % [facing, slot])
				return false
	current_facing = facing
	mirror_root.scale.x = -1.0 if wants_mirror else 1.0
	parts_changed.emit()
	return true


func set_armor_visible(v: bool) -> void:
	for slot in attached:
		attached[slot]["sprite"].visible = v
	parts_changed.emit()


func clear_all() -> void:
	for slot in attached:
		var s: Sprite2D = attached[slot]["sprite"]
		s.texture = null
		s.visible = false
	attached.clear()


func attached_slots() -> PackedStringArray:
	var out: PackedStringArray = []
	for slot in attached:
		out.append(slot)
	out.sort()
	return out


func _problem(code: String, slot: String, message: String) -> void:
	problems.append({"code": code, "slot": slot, "message": message})
