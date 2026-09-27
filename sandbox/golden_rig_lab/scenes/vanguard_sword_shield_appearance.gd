extends Node2D
## Visual-only appearance scene for VANGUARD_SWORD_SHIELD (GODOT_SCENE_CONTRACT.md).
## Owns no gameplay state (no HP, targeting, movement or combat).
## The Bone2D hierarchy in the .tscn is generated from the P1.5 manifest by
## tools/generate_appearance_scene.gd and re-verified against it here (GR020/GR022/GR023).

const RigManifestScript = preload("res://rig/rig_manifest.gd")
const RigBuilderScript = preload("res://rig/rig_builder.gd")
const VisualAssemblerScript = preload("res://rig/visual_assembler.gd")

@export var manifest_path: String = "res://contracts/manifests/vanguard_sword_shield.rig.json"

var manifest: RigManifestScript
var verify_errors: PackedStringArray = []

@onready var mirror_root: Node2D = $MirrorRoot
@onready var skeleton: Skeleton2D = $MirrorRoot/Skeleton2D
@onready var assembler: VisualAssemblerScript = $VisualAssembler
@onready var debug_overlay: Node2D = $DebugOverlay
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	manifest = RigManifestScript.load_from(manifest_path)
	verify_errors = manifest.errors.duplicate()
	verify_errors.append_array(RigBuilderScript.verify(manifest, skeleton))
	RigBuilderScript.apply_rest_pose(skeleton)
	animation_tree.active = false   # pilot: AnimationPlayer is the authority; no blend graph exists
	assembler.setup(manifest, skeleton, mirror_root)
	debug_overlay.setup(manifest, skeleton, assembler, mirror_root)
	for e in verify_errors:
		push_warning("[appearance] %s" % e)


func rig_is_verified() -> bool:
	return verify_errors.is_empty()
