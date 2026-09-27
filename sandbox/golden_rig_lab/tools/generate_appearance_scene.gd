extends SceneTree
## Generates scenes/vanguard_sword_shield_appearance.tscn.
## Bones, rest transforms and sockets come ONLY from the P1.5 manifest (RigBuilder).
## Sprite/Marker node names and order come from GODOT_SCENE_CONTRACT.md.
## Run from the sandbox project dir:
##   godot --headless --path . -s tools/generate_appearance_scene.gd

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const RigBuilderScript = preload("res://rig/rig_builder.gd")
const OUT := "res://scenes/vanguard_sword_shield_appearance.tscn"

## Sprite2D children per bone, in contract order (listed before child bones under each bone).
## waist_tabard: "waist_tabard and waist accessories are children of hip".
const BONE_SPRITES := {
	"hip": ["waist_tabard"],
	"torso": ["body_torso", "armor_torso", "cape_back", "chest_accessory"],
	"head": ["head_base", "face_overlay", "scar_overlay", "hair_back", "hair_front", "head_accessory"],
	"upper_arm_l": ["body_upper_arm_l", "armor_upper_arm_l"],
	"forearm_hand_l": ["body_forearm_hand_l", "armor_forearm_hand_l"],
	"upper_arm_r": ["body_upper_arm_r", "armor_upper_arm_r"],
	"forearm_hand_r": ["body_forearm_hand_r", "armor_forearm_hand_r"],
	"thigh_l": ["body_thigh_l", "armor_thigh_l"],
	"lower_leg_boot_l": ["body_lower_leg_l", "armor_lower_leg_boot_l"],
	"thigh_r": ["body_thigh_r", "armor_thigh_r"],
	"lower_leg_boot_r": ["body_lower_leg_r", "armor_lower_leg_boot_r"],
}
## Sprite2D children of sockets (contract tree).
const SOCKET_SPRITES := {
	"weapon_main_socket": "weapon_main",
	"offhand_socket": "offhand",
}


func _init() -> void:
	var manifest = RigManifestScript.load_from()
	if not manifest.is_valid():
		for e in manifest.errors:
			push_error(e)
		printerr("manifest invalid, scene not generated")
		quit(1)
		return

	var root := Node2D.new()
	root.name = "VanguardSwordShieldAppearance"
	root.set_script(load("res://scenes/vanguard_sword_shield_appearance.gd"))

	var shadow := Sprite2D.new()
	shadow.name = "ContactShadow"
	shadow.position = Vector2(manifest.center_axis_x, manifest.ground_y)
	root.add_child(shadow)

	var mirror := Node2D.new()
	mirror.name = "MirrorRoot"
	mirror.position = Vector2(manifest.center_axis_x, 0)
	root.add_child(mirror)

	var skeleton := Skeleton2D.new()
	skeleton.name = "Skeleton2D"
	mirror.add_child(skeleton)

	var bones: Dictionary = RigBuilderScript.build_bones(manifest, skeleton)
	for bone_id in BONE_SPRITES:
		if not bones.has(bone_id):
			push_error("scene contract references bone %s not in manifest" % bone_id)
			quit(1)
			return
		var bone: Node = bones[bone_id]
		var i := 0
		for sprite_name in BONE_SPRITES[bone_id]:
			var sp := _sprite(sprite_name)
			bone.add_child(sp)
			bone.move_child(sp, i)
			i += 1
	var sockets: Dictionary = RigBuilderScript.build_sockets(manifest, bones)
	for socket_id in SOCKET_SPRITES:
		if sockets.has(socket_id):
			sockets[socket_id].add_child(_sprite(SOCKET_SPRITES[socket_id]))

	var ap := AnimationPlayer.new()
	ap.name = "AnimationPlayer"
	root.add_child(ap)
	var at := AnimationTree.new()
	at.name = "AnimationTree"
	at.active = false
	root.add_child(at)
	var assembler := Node.new()
	assembler.name = "VisualAssembler"
	assembler.set_script(load("res://rig/visual_assembler.gd"))
	root.add_child(assembler)
	var overlay := Node2D.new()
	overlay.name = "DebugOverlay"
	overlay.set_script(load("res://scenes/debug_overlay.gd"))
	root.add_child(overlay)

	_set_owner(root, root)
	var packed := PackedScene.new()
	var err := packed.pack(root)
	if err != OK:
		printerr("pack failed: ", error_string(err))
		quit(1)
		return
	err = ResourceSaver.save(packed, OUT)
	if err != OK:
		printerr("save failed: ", error_string(err))
		quit(1)
		return
	print("generated ", OUT, " — bones: ", bones.size(), ", sockets: ", sockets.size())
	_print_tree(root, "")
	root.free()
	quit(0)


func _sprite(n: String) -> Sprite2D:
	var s := Sprite2D.new()
	s.name = n
	s.centered = true
	s.z_as_relative = false
	s.z_index = 0
	return s


func _set_owner(node: Node, owner: Node) -> void:
	for c in node.get_children():
		c.owner = owner
		_set_owner(c, owner)


func _print_tree(node: Node, indent: String) -> void:
	var extra := ""
	if node is Bone2D:
		extra = "  rest=%s len=%.1f" % [node.rest.origin, node.get_length()]
	elif node is Marker2D:
		extra = "  pos=%s" % node.position
	print(indent, node.name, " (", node.get_class(), ")", extra)
	for c in node.get_children():
		_print_tree(c, indent + "  ")
