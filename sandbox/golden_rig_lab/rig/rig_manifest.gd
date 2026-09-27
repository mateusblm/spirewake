class_name RigManifest
extends RefCounted
## Read-only loader for the frozen P1.5 rig manifest (agent-contract/manifests/*.rig.json).
## Every anchor, bone, socket and z-lane used anywhere in the Lab comes from here.
## Nothing in this class may be mutated by callers.

const DEFAULT_PATH := "res://contracts/manifests/vanguard_sword_shield.rig.json"

var path: String = ""
var data: Dictionary = {}
var rig_id: String = ""
var status: String = ""
var canvas_size: Vector2 = Vector2(512, 512)
var center_axis_x: float = 256.0
var ground_y: float = 448.0
var canonical_facing: String = "right"
var authored_views: PackedStringArray = []
var horizontal_facing: Dictionary = {}
var primary_markers: Dictionary = {}    # name -> Vector2 (absolute logical px)
var secondary_pivots: Dictionary = {}   # name -> Vector2
var markers: Dictionary = {}            # union of the two above
var bones: Array[Dictionary] = []       # manifest order preserved
var bone_by_id: Dictionary = {}
var sockets: Array[Dictionary] = []
var socket_by_id: Dictionary = {}
var z_lanes: Dictionary = {}
var rules: Dictionary = {}
var errors: PackedStringArray = []      # GR001 / GR020 / GR021 / GR022 style messages


static func load_from(p: String = DEFAULT_PATH) -> RigManifest:
	var m := RigManifest.new()
	m.path = p
	if not FileAccess.file_exists(p):
		m.errors.append("GR001 manifest not found: %s" % p)
		return m
	var json := JSON.new()
	var err := json.parse(FileAccess.get_file_as_string(p))
	if err != OK:
		m.errors.append("GR001 manifest JSON parse error (line %d): %s" % [json.get_error_line(), json.get_error_message()])
		return m
	if typeof(json.data) != TYPE_DICTIONARY:
		m.errors.append("GR001 manifest root is not an object")
		return m
	m.data = json.data
	m._parse()
	return m


static func _v2(a) -> Vector2:
	if typeof(a) == TYPE_ARRAY and a.size() >= 2:
		return Vector2(float(a[0]), float(a[1]))
	return Vector2.ZERO


func _parse() -> void:
	rig_id = str(data.get("rig_id", ""))
	status = str(data.get("status", ""))
	var lc: Dictionary = data.get("logical_canvas", {})
	canvas_size = Vector2(float(lc.get("width", 512)), float(lc.get("height", 512)))
	center_axis_x = float(data.get("center_axis_x", 256))
	ground_y = float(data.get("ground_y", 448))
	canonical_facing = str(data.get("canonical_source_facing", "right"))
	for v in data.get("authored_views", []):
		authored_views.append(str(v))
	horizontal_facing = data.get("horizontal_facing", {})
	var geo: Dictionary = data.get("geometry", {})
	var prim: Dictionary = geo.get("primary_markers_absolute", {})
	for k in prim:
		primary_markers[k] = _v2(prim[k])
		markers[k] = primary_markers[k]
	var sec: Dictionary = geo.get("secondary_pivots_absolute", {})
	for k in sec:
		secondary_pivots[k] = _v2(sec[k])
		markers[k] = secondary_pivots[k]
	for raw in data.get("bones", []):
		var b := {
			"id": str(raw.get("id", "")),
			"parent": raw.get("parent"),  # null or String
			"rest_position_local": _v2(raw.get("rest_position_local", [0, 0])),
			"pivot_absolute": _v2(raw.get("pivot_absolute", [0, 0])),
			"rest_rotation_deg": float(raw.get("rest_rotation_deg", 0.0)),
			"editor_length": float(raw.get("editor_length", 0.0)),
			"end_marker": raw.get("end_marker", null),
		}
		if b["parent"] != null:
			b["parent"] = str(b["parent"])
		if bone_by_id.has(b["id"]):
			errors.append("GR021 duplicate bone id %s" % b["id"])
			continue
		bones.append(b)
		bone_by_id[b["id"]] = b
	for raw in data.get("sockets", []):
		var s := {
			"id": str(raw.get("id", "")),
			"parent_bone": str(raw.get("parent_bone", "")),
			"absolute_marker": raw.get("absolute_marker", null),
			"local_position": _v2(raw.get("local_position", [0, 0])),
		}
		if socket_by_id.has(s["id"]):
			errors.append("GR021 duplicate socket id %s" % s["id"])
			continue
		sockets.append(s)
		socket_by_id[s["id"]] = s
	z_lanes = data.get("z_lanes", {})
	rules = data.get("rules", {})
	_validate_graph()


func _validate_graph() -> void:
	# Parent references, cycles and self-consistency of rest transforms vs absolute pivots.
	for b in bones:
		if b["parent"] != null and not bone_by_id.has(b["parent"]):
			errors.append("GR020 bone %s references unknown parent %s" % [b["id"], b["parent"]])
		if b["end_marker"] != null and not markers.has(str(b["end_marker"])):
			errors.append("GR020 bone %s references unknown end_marker %s" % [b["id"], b["end_marker"]])
		var seen := {b["id"]: true}
		var cur = b["parent"]
		while cur != null:
			if seen.has(cur):
				errors.append("GR021 bone graph cycle through %s" % b["id"])
				break
			seen[cur] = true
			cur = bone_by_id.get(cur, {}).get("parent", null)
		# rest_position_local accumulated from MirrorRoot(center_axis_x, 0) must equal pivot_absolute.
		var expected: Vector2
		if b["parent"] == null:
			expected = Vector2(center_axis_x, 0) + b["rest_position_local"]
		elif bone_by_id.has(b["parent"]):
			expected = bone_by_id[b["parent"]]["pivot_absolute"] + b["rest_position_local"]
		else:
			continue
		if expected.distance_to(b["pivot_absolute"]) > 0.001:
			errors.append("GR022 bone %s rest_position_local %s does not resolve to pivot_absolute %s (got %s)" % [b["id"], b["rest_position_local"], b["pivot_absolute"], expected])
	for s in sockets:
		if not bone_by_id.has(s["parent_bone"]):
			errors.append("GR020 socket %s references unknown bone %s" % [s["id"], s["parent_bone"]])
		elif s["absolute_marker"] != null:
			var abs_expected: Vector2 = bone_by_id[s["parent_bone"]]["pivot_absolute"] + s["local_position"]
			var mk := str(s["absolute_marker"])
			if markers.has(mk) and abs_expected.distance_to(markers[mk]) > 0.001:
				errors.append("GR022 socket %s local_position does not land on marker %s" % [s["id"], mk])


func is_valid() -> bool:
	return errors.is_empty()


func marker(name: String) -> Vector2:
	return markers.get(name, Vector2.ZERO)


func has_marker(name: String) -> bool:
	return markers.has(name)


func bone(id: String) -> Dictionary:
	return bone_by_id.get(id, {})


func has_bone(id: String) -> bool:
	return bone_by_id.has(id)


func has_socket(id: String) -> bool:
	return socket_by_id.has(id)


## Vector from the bone pivot to its end marker, in the bone's local (rest) space.
func bone_end_local(id: String) -> Vector2:
	var b := bone(id)
	if b.is_empty() or b["end_marker"] == null:
		return Vector2.ZERO
	return marker(str(b["end_marker"])) - b["pivot_absolute"]


func z_lane(name: String) -> int:
	return int(z_lanes.get(name, 0))


func mirror_x_for_facing(facing: String) -> bool:
	var f: Dictionary = horizontal_facing.get(facing, {})
	return bool(f.get("mirror_x", false))
