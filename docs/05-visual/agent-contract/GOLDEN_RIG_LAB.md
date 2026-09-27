# Golden Rig Lab Contract

**Purpose:** a single isolated visual test bench shared by Claude, Codex and human review.

**Status:** FROZEN CONTRACT  
**Pilot:** `VANGUARD_SWORD_SHIELD`

The Lab must use the same production assembly/catalog code intended for gameplay. It must not be a disconnected mock scene with separate special-case assembly logic.

## 1. Mandatory capabilities

Controls:

- View: `FRONT_3Q` / `BACK_3Q`
- Facing: `Direita` / `Esquerda`
- Animation selector
- Armor set selector
- Hair selector
- Weapon selector
- Shield selector
- Toggle bones
- Toggle pivots / sockets
- Toggle logical 512×512 canvas
- Toggle absolute `z_index` labels
- Reset to Golden DNA
- Load each Swap Test fixture
- Export screenshot

For the first implementation gate (`P2.4B-0`), only these are mandatory:

- `FRONT_3Q`
- rest pose
- armor part loading
- bones/pivots/sockets debug overlay
- 512 logical canvas overlay
- absolute z-index labels
- clean composite screenshot
- debug screenshot

Do not implement BACK_3Q, animation playback or gameplay until the first FRONT_3Q reassembly is reviewed.

## 2. Default fixture

On open:

```text
fixture = kael_golden.visual_dna.json
view = FRONT_3Q
facing = RIGHT
animation = idle_rest
time = 0
```

If the complete Golden DNA catalog is not yet implemented, the P2.4B-0 Lab may load the ten Blackguard armor assets directly through their metadata while keeping the exact same rig/assembler path intended for production.

## 3. Required review modes

### Geometry mode

Neutral background.

Show:

- logical canvas bounds;
- center axis;
- ground line;
- all bones;
- primary joints;
- secondary pivots;
- sockets;
- slot names.

### Art mode

Dark neutral background.

Show:

- no debug marks;
- assembled character appearance;
- intended gameplay scale;
- current asset IDs in an external/dev panel only.

### Z-order mode

Show each visible modular part with its current **absolute** `z_index`.

### Contact-sheet mode

After animation work begins, capture the same normalized animation timestamps for all Swap Test cases.

Not required in P2.4B-0.

## 4. Production-code rule

The Lab must:

- use the same `VisualAssembler` / catalog path intended for production;
- consume the same metadata contract;
- consume the same P1.5 rig manifest;
- avoid duplicate hard-coded pivot values inside the Lab.

The Lab may be located under a sandbox/dev path until repository architecture is frozen.

## 5. No production coupling

The Lab must not:

- own gameplay state;
- own HP, targeting, movement or combat logic;
- mutate persisted VisualDNA;
- introduce special rig code not used by the production assembler;
- contain per-fixture fixes;
- modify P1.5 bone geometry.

## 6. FRONT_3Q P2.4B-0 workflow

1. Load `vanguard_sword_shield.rig.json`.
2. Construct or verify the frozen `Skeleton2D/Bone2D` hierarchy.
3. Load the ten `armor_blackguard_01` FRONT_3Q assets.
4. Normalize each asset into logical 512×512 space through metadata.
5. Attach each slot to its required bone.
6. Apply explicit z-index.
7. Render Geometry mode.
8. Render clean Art mode.
9. Capture joint closeups.
10. Report mismatches.

If any asset only fits after moving a shared bone/anchor, stop and report the slot. Do not modify the shared rig.

## 7. Required screenshots for P2.4B

Return:

1. Lab scene open;
2. empty/shared rig with bones + pivots;
3. full `armor_blackguard_01` FRONT_3Q reconstruction;
4. left shoulder/elbow closeup;
5. right shoulder/elbow closeup;
6. left hip/knee/boot closeup;
7. right hip/knee/boot closeup;
8. waist/tabard overlap closeup.

## 8. Screenshot naming

```text
<fixture>__<view>__<facing>__<mode>.png
```

Examples:

```text
blackguard_p2_4b__front3q__right__geometry.png
blackguard_p2_4b__front3q__right__art.png
blackguard_p2_4b__front3q__right__zorder.png
```

After animation support exists:

```text
<fixture>__<view>__<facing>__<clip>__<normalized_time>.png
```

## 9. Acceptance

The Golden Rig Lab implementation passes its first gate only when:

- it derives bones/rest transforms from the rig manifest;
- no anchor value is eyeballed from artwork;
- the ten FRONT_3Q assets can be loaded independently;
- all slot transforms live in metadata/configuration, not one-off scene edits;
- clean/debug screenshots can be produced reproducibly;
- no gameplay code is required to use the Lab.
