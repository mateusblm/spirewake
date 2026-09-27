# Godot Scene Contract — Golden Rig Pilot

**Status:** PROPOSED FOR FREEZE  
**Target:** Godot 4.7.x / `VANGUARD_SWORD_SHIELD`

The appearance scene is visual-only. Gameplay movement, HP, targeting, collisions and combat decisions stay outside it.

## Canonical scene tree

```text
VanguardSwordShieldAppearance (Node2D)
├── ContactShadow (Sprite2D)
├── MirrorRoot (Node2D)                # position=(256,0), scale.x=+1/-1
│   └── Skeleton2D (Skeleton2D)
│       └── hip (Bone2D)
│           ├── torso (Bone2D)
│           │   ├── body_torso (Sprite2D)
│           │   ├── armor_torso (Sprite2D)
│           │   ├── cape_back (Sprite2D)
│           │   ├── chest_accessory (Sprite2D)
│           │   ├── head (Bone2D)
│           │   │   ├── head_base (Sprite2D)
│           │   │   ├── face_overlay (Sprite2D)
│           │   │   ├── scar_overlay (Sprite2D)
│           │   │   ├── hair_back (Sprite2D)
│           │   │   ├── hair_front (Sprite2D)
│           │   │   └── head_accessory (Sprite2D)
│           │   ├── upper_arm_l (Bone2D)
│           │   │   ├── body_upper_arm_l (Sprite2D)
│           │   │   ├── armor_upper_arm_l (Sprite2D)
│           │   │   └── forearm_hand_l (Bone2D)
│           │   │       ├── body_forearm_hand_l (Sprite2D)
│           │   │       ├── armor_forearm_hand_l (Sprite2D)
│           │   │       └── offhand_socket (Marker2D)
│           │   │           └── offhand (Sprite2D)
│           │   └── upper_arm_r (Bone2D)
│           │       ├── body_upper_arm_r (Sprite2D)
│           │       ├── armor_upper_arm_r (Sprite2D)
│           │       └── forearm_hand_r (Bone2D)
│           │           ├── body_forearm_hand_r (Sprite2D)
│           │           ├── armor_forearm_hand_r (Sprite2D)
│           │           └── weapon_main_socket (Marker2D)
│           │               └── weapon_main (Sprite2D)
│           ├── thigh_l (Bone2D)
│           │   ├── body_thigh_l (Sprite2D)
│           │   ├── armor_thigh_l (Sprite2D)
│           │   └── lower_leg_boot_l (Bone2D)
│           │       ├── body_lower_leg_l (Sprite2D)
│           │       └── armor_lower_leg_boot_l (Sprite2D)
│           └── thigh_r (Bone2D)
│               ├── body_thigh_r (Sprite2D)
│               ├── armor_thigh_r (Sprite2D)
│               └── lower_leg_boot_r (Bone2D)
│                   ├── body_lower_leg_r (Sprite2D)
│                   └── armor_lower_leg_boot_r (Sprite2D)
├── AnimationPlayer (AnimationPlayer)
├── AnimationTree (AnimationTree)      # optional, disabled in pilot
├── VisualAssembler (Node)
└── DebugOverlay (Node2D)              # dev only
```

`waist_tabard` and waist accessories are children of `hip`.

## Root/mirror policy

- Artwork stays in logical 512×512 coordinates.
- `MirrorRoot.position = Vector2(256, 0)`.
- Bone X values are stored relative to center axis.
- canonical source facing = right.
- mirror only when every selected family is `mirror_safe=true`.
- mirroring never renames anatomical L/R bones.

## Rest transform source

Use only:

`agent-contract/manifests/vanguard_sword_shield.rig.json`

Do not measure the P0 art.

## Sprite placement invariant

For full-canvas normalized 512×512 textures attached at a semantic pivot:

```text
sprite_local_position = Vector2(256,256) - pivot_source
```

For trimmed build textures, the compiler must reconstruct the same placement from `canvas_offset + pivot`.

## Z-order

Every modular Sprite2D must use:

```text
z_as_relative = false
```

and an explicit absolute `z_index` from metadata.

Do not rely on scene-tree order for procedural layering.

Animation tracks may override `z_index`/`visible` where a crossing is authored.

## Views

Switching `front_3q` ↔ `back_3q`:

- reuses the same skeleton;
- moves no bones;
- swaps view textures/metadata;
- reapplies explicit z-index values.

## IK

Runtime IK is forbidden in the V1 pilot.

## Animation authority

Use `AnimationPlayer` for the pilot.

`AnimationTree` may exist disabled for future blending but no agent may invent a blend graph before a separate decision.

## DebugOverlay

Must support:

- 512 canvas bounds
- center axis
- ground line
- all joints/pivots
- sockets
- current view
- current asset IDs
- current z-index labels
