class_name RigBuilder
extends RefCounted
## Builds and verifies the Skeleton2D/Bone2D hierarchy strictly from a RigManifest.
## Used by tools/generate_appearance_scene.gd (construct) and at runtime (verify: GR020/GR022/GR023).

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const REST_EPSILON := 0.001


## Creates Bone2D nodes under `skeleton` following the manifest hierarchy. Returns id -> Bone2D.
static func build_bones(manifest: RigManifestScript, skeleton: Skeleton2D) -> Dictionary:
	var nodes := {}
	for b in manifest.bones:
		var bone := Bone2D.new()
		bone.name = b["id"]
		configure_bone(bone, b, manifest)
		var parent: Node = skeleton if b["parent"] == null else nodes.get(b["parent"])
		assert(parent != null, "RigBuilder: parent bone missing for %s" % b["id"])
		parent.add_child(bone)
		nodes[b["id"]] = bone
	return nodes


static func configure_bone(bone: Bone2D, b: Dictionary, manifest: RigManifestScript) -> void:
	var rot: float = deg_to_rad(b["rest_rotation_deg"])
	bone.rest = Transform2D(rot, b["rest_position_local"])
	bone.position = b["rest_position_local"]
	bone.rotation = rot
	bone.set_autocalculate_length_and_angle(false)
	bone.set_length(b["editor_length"])
	var end_local: Vector2 = manifest.bone_end_local(b["id"])
	bone.set_bone_angle(end_local.angle() if end_local != Vector2.ZERO else 0.0)


## Creates Marker2D sockets declared in the manifest under their parent bones. Returns id -> Marker2D.
static func build_sockets(manifest: RigManifestScript, bones: Dictionary) -> Dictionary:
	var out := {}
	for s in manifest.sockets:
		var parent: Node = bones.get(s["parent_bone"])
		if parent == null:
			continue
		var m := Marker2D.new()
		m.name = s["id"]
		m.position = s["local_position"]
		parent.add_child(m)
		out[s["id"]] = m
	return out


## Verifies an existing skeleton against the manifest. Returns error strings (empty = OK).
static func verify(manifest: RigManifestScript, skeleton: Skeleton2D) -> PackedStringArray:
	var errors: PackedStringArray = []
	var found := {}
	for b in manifest.bones:
		var bone := skeleton.find_child(b["id"], true, false) as Bone2D
		if bone == null:
			errors.append("GR022 bone %s missing from scene" % b["id"])
			continue
		found[b["id"]] = true
		var expected_parent_name: String = skeleton.name if b["parent"] == null else str(b["parent"])
		if bone.get_parent().name != expected_parent_name:
			errors.append("GR022 bone %s parent is %s, manifest says %s" % [b["id"], bone.get_parent().name, expected_parent_name])
		var rest: Transform2D = bone.rest
		if rest.origin.distance_to(b["rest_position_local"]) > REST_EPSILON:
			errors.append("GR022 bone %s rest origin %s != manifest %s" % [b["id"], rest.origin, b["rest_position_local"]])
		if absf(rad_to_deg(rest.get_rotation()) - b["rest_rotation_deg"]) > REST_EPSILON:
			errors.append("GR022 bone %s rest rotation %.3f != manifest %.3f" % [b["id"], rad_to_deg(rest.get_rotation()), b["rest_rotation_deg"]])
	# Any Bone2D not declared in the manifest is a character-specific bone (GR023).
	for extra in all_bones(skeleton):
		if not found.has(extra.name):
			errors.append("GR023 undeclared Bone2D %s present in scene" % extra.name)
	for s in manifest.sockets:
		var sock := skeleton.find_child(s["id"], true, false) as Node2D
		if sock == null:
			errors.append("GR020 socket %s missing from scene" % s["id"])
		elif sock.get_parent().name != s["parent_bone"]:
			errors.append("GR022 socket %s parent is %s, manifest says %s" % [s["id"], sock.get_parent().name, s["parent_bone"]])
		elif sock.position.distance_to(s["local_position"]) > REST_EPSILON:
			errors.append("GR022 socket %s position %s != manifest %s" % [s["id"], sock.position, s["local_position"]])
	return errors


static func all_bones(root: Node) -> Array[Bone2D]:
	var out: Array[Bone2D] = []
	for c in root.get_children():
		if c is Bone2D:
			out.append(c)
		out.append_array(all_bones(c))
	return out


## Puts every bone back in its manifest rest pose (P2.4B-0 has no animation).
static func apply_rest_pose(skeleton: Skeleton2D) -> void:
	for b in all_bones(skeleton):
		b.apply_rest()
