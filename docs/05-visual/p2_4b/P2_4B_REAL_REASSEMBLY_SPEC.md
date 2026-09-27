# Spirewake — P2.4B Real Reassembly Gate (FRONT_3Q)

**Armor set:** `armor_blackguard_01`  
**View:** `FRONT_3Q`  
**Input:** the 10 approved candidate PNGs in this package  
**Status:** READY FOR REAL REASSEMBLY

## Objective

Reconstruct the Blackguard FRONT_3Q using **only the ten candidate PNGs in this package** and the frozen P1.5 shared rig.

This is the first real proof that the modular asset pipeline works.

No candidate is final merely because it looks good in isolation.

## Canonical input slots

1. `torso`
2. `upper_arm_l`
3. `upper_arm_r`
4. `forearm_hand_l`
5. `forearm_hand_r`
6. `thigh_l`
7. `thigh_r`
8. `lower_leg_boot_l`
9. `lower_leg_boot_r`
10. `waist_tabard`

## Required rig references

Use P1 v2 / P1.5 canonical geometry:

- `SHOULDER_L`
- `SHOULDER_R`
- `ELBOW_L`
- `ELBOW_R`
- `HIP_L`
- `HIP_R`
- `KNEE_L`
- `KNEE_R`
- `HIP`

Do not measure or redefine anchors from the art.

## Allowed corrections during this gate

Allowed:

- asset-local scale normalization;
- local pivot placement;
- local canvas offset;
- explicit z-index;
- alpha cleanup;
- minor transparent padding changes;
- metadata corrections.

Not allowed:

- moving shared P1.5 anchors;
- changing bone hierarchy;
- adding a new bone;
- character-specific rig exceptions;
- stretching/warping a rigid armor piece to make it fit;
- manually painting over intersections in the final composite;
- replacing a part silently.

## Mandatory reconstruction order

1. normalize all sources into canonical logical space;
2. place `torso`;
3. place thighs + lower-leg/boots;
4. place `waist_tabard`;
5. place upper arms;
6. place forearm/hands;
7. apply canonical FRONT_3Q z-order;
8. render debug overlay;
9. render clean armor-only composite;
10. review before any BACK_3Q production continues.

## Required review outputs

The Golden Rig Lab / implementation agent must return:

### A. Geometry render
- neutral background;
- all pivots visible;
- bone lines visible;
- slot names visible.

### B. Clean composite
- no debug overlays;
- same intended gameplay scale;
- only the ten Blackguard armor parts.

### C. Joint closeups
At minimum:
- left shoulder/elbow;
- right shoulder/elbow;
- left hip/knee/boot;
- right hip/knee/boot;
- waist/tabard overlap.

### D. Error report
For every visible mismatch:

```text
slot:
problem:
asset-local fix possible? yes/no
metadata-only fix possible? yes/no
would require shared-rig exception? yes/no
```

If `would require shared-rig exception = yes`, the asset fails and must be regenerated.

## Acceptance criteria

P2.4B passes only if:

- 10/10 candidates assemble;
- no joint looks broken;
- boots connect naturally;
- waist/tabard layers cleanly over/around thighs;
- upper/forearm pieces meet at elbows without obvious gaps or impossible overlap;
- no shared rig point is moved;
- all correction is reproducible through asset metadata;
- final silhouette still reads as the approved Blackguard FRONT_3Q.

## After approval

Freeze these ten files as:

`armor_blackguard_01 / FRONT_3Q / v1`

Then begin P2.4C: production of the ten BACK_3Q individual assets.
