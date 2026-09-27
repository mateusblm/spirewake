# Animation Semantics Contract — VANGUARD_SWORD_SHIELD

**Status:** semantics fixed for P1.5; exact bone curves are frozen only after P3 visual approval.

| Clip | Loop | Baseline | Required event |
|---|---:|---:|---|
| `idle_rest` | yes | 1.60 s | — |
| `attack_slash_horizontal` | no | 0.72 s | `impact` |
| `hit_react` | no | 0.36 s | — |
| `death` | no | 0.90 s | `death_settle` |
| `intercept_protect` | no | 0.62 s | `guard_active` |

Allowed tracks:

- Bone2D rotation
- small local Bone2D position offsets
- Sprite2D z_index / visible
- hair/cape secondary motion
- FX visibility/opacity

Forbidden:

- hierarchy changes
- pivot changes
- character-specific clips
- anchor-to-anchor gameplay translation inside animation
- runtime IK repair

## Horizontal slash key semantics

| normalized time | meaning |
|---:|---|
| 0.00 | ready |
| 0.20 | wind-up |
| 0.42 | blade begins lateral crossing |
| 0.56 | impact |
| 0.76 | follow-through |
| 1.00 | recovery |

It must read as a lateral cut, not an overhead cut and not an arm rotating unnaturally around a fixed shoulder.

## Intercept

Gameplay owns movement between combat anchors.  
The clip owns the brace/protection pose.  
`guard_active` marks the readable defensive moment.

## P3 gate

P3 must provide both views, contact sheets, gameplay-scale screenshots and z-order crossing proof. Only then freeze exact transforms.
