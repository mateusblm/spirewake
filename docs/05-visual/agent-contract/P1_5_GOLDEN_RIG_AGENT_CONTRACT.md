# Spirewake — P1.5 Golden Rig Agent Contract

**Version:** 1.0  
**Status:** PROPOSED FOR FREEZE  
**Pilot:** `VANGUARD_SWORD_SHIELD`

P0 defines appearance.  
P1 v2 defines shared geometry.  
P1.5 defines how agents may implement and validate that system.

> The agent implements a contract. The agent does not invent a visual rule.

## Precedence

1. this P1.5 contract
2. machine-readable manifests/schemas
3. P1 v2 geometry
4. `GOLDEN_RIG.md`
5. P0/master mockups for art direction only

## Fixed pilot constraints

- Godot 4.7.x family
- visual component isolated from gameplay logic
- shared rig by weapon archetype
- `front_3q` + `back_3q`
- canonical source facing = right
- canvas = 512×512
- center x = 256
- ground y = 448
- no runtime IK
- shared FK/cutout clips
- explicit metadata for every part
- armor set is atomic
- no character-specific bone/anchor fixes
- source-normalized pilot PNGs remain full 512×512
- trim/atlas only after preserving pivot/offset invariants

Godot's official 2D skeleton/cutout model supports shared `Skeleton2D/Bone2D` hierarchies, relative rest transforms, property animation, explicit 2D draw order and selective cel animation; those engine capabilities are the technical basis for this contract.

## Machine-readable files

```text
agent-contract/
├── schemas/
│   ├── rig_definition.schema.json
│   ├── visual_part.schema.json
│   ├── armor_set.schema.json
│   └── visual_dna.schema.json
├── manifests/
│   └── vanguard_sword_shield.rig.json
├── examples/
│   ├── sword_straight_01.visual_part.json
│   └── armor_blackguard_01.armor_set.json
└── fixtures/
    ├── kael_golden.visual_dna.json
    └── swap_test_cases.json
```

These JSON files are the interchange contract. Final architecture may compile them to custom Godot Resources, but may not change semantics silently.

## Procedural sequence

```text
resolve archetype
→ body/skin/face
→ filter + choose hair
→ filter + choose armor_set
→ filter + choose weapon
→ filter + choose offhand
→ filter + choose cape/accessories
→ persist final VisualDNA IDs
→ assemble selected view
```

`requires` are hard requirements.  
`excludes` are hard prohibitions.  
Armor subpieces never enter RNG individually.

If filtering produces no candidates, use an explicit deterministic fallback and report it. Never silently choose a random invalid part.

## Determinism

Use substreams derived from `visual_seed` for:

`body`, `skin`, `face`, `scar`, `hair`, `armor`, `weapon`, `offhand`, `cape`, `accessory`, `palette`.

Final IDs are persisted. Existing characters do not reroll because a catalog changes.

## Asset placement

Per view, every visual part declares:

- texture source
- attachment kind
- bone/socket
- semantic pivot
- 512 source canvas
- explicit z-index
- trim reconstruction data if optimized

Never infer pivot from alpha bounds or image center.

## Agent responsibilities

### ChatGPT
- art direction
- source asset generation/refinement
- visual review
- gate approval

### Claude
- Golden Rig Lab scene composition
- visual integration
- screenshot iteration
- z-order review
- metadata-only corrections, never rig exceptions

### Codex
- schema/catalog loaders
- VisualAssembler
- deterministic RNG
- validator
- fixtures/tests
- future trim/atlas compiler

## Forbidden agent behavior

- adding a bone because one asset does not fit
- moving a shared anchor for one character
- hand-fixing one Swap Test combination
- mixing armor subpieces across sets
- adding runtime IK to repair a pose
- inferring compatibility from appearance
- silently rerolling invalid DNA
- replacing a missing part randomly
- measuring mockups to redefine P1 geometry
- treating generated text inside mockups as technical data

## Gate to P2

P2 begins only after P1.5 approval.

Then the first real production asset is:

`armor_blackguard_01`

in both views, normalized to this contract.
