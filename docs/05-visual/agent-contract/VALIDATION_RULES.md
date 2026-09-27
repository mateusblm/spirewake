# Golden Rig Validation Contract

Strict validation is required before a part enters the approved catalog.

## Automated checks

- `GR001 ERROR` manifest does not validate against schema
- `GR002 ERROR` duplicate ID
- `GR003 ERROR` referenced asset ID missing
- `GR010 ERROR` front/back view missing
- `GR011 ERROR` normalized pilot PNG is not 512×512
- `GR012 ERROR` source has no alpha/RGBA
- `GR013 ERROR` pivot outside logical canvas
- `GR020 ERROR` unknown bone/socket
- `GR021 ERROR` bone graph cycle/duplicate
- `GR022 ERROR` rest geometry differs from canonical manifest
- `GR023 ERROR` character-specific bone/anchor override exists
- `GR024 ERROR` runtime IK present
- `GR030 ERROR` armor set missing mandatory piece
- `GR031 ERROR` armor set references foreign-set piece
- `GR040 ERROR` `requires` not satisfied
- `GR041 ERROR` candidate matches an `excludes` tag
- `GR042 ERROR` valid candidate pool becomes empty without explicit fallback
- `GR043 WARNING` deterministic fallback used
- `GR050 ERROR` trim/reconstruct pivot drift > 0.5 logical px
- `GR051 ERROR` reconstructed canvas placement drift > 1 logical px
- `GR052 WARNING` alpha touches 512 canvas edge
- `GR060 ERROR` Kael Golden fixture cannot resolve
- `GR061 ERROR` one of 8 Swap Test fixtures cannot resolve
- `GR062 ERROR` same seed/catalog version resolves to different final IDs

## Manual visual gates

- shoulder/elbow/knee do not look broken
- boot remains connected
- sword/shield grips read correctly
- hair does not cut through large shoulders
- cape does not cross torso at idle
- front/back read as the same person
- mirrored view remains valid when marked mirror-safe
- zero per-combination fix for all 8 Swap Test cases

## Validator output

```json
{
  "ok": false,
  "errors": [
    {"code":"GR030","asset_id":"armor_blackguard_01","message":"Missing lower_leg_boot_r"}
  ],
  "warnings": []
}
```
