# Spirewake — P1 Technical Rig Spec v2

**Archetype:** `VANGUARD_SWORD_SHIELD`  
**Status:** PROPOSED — aguardando aprovação  
**Supersedes:** P1 v1 (invalidado por anchors projetados sobre um crop aproximado)  
**Art reference:** P0 Master Reference  
**Geometry source of truth:** este documento

## 1. Princípio central

O P0 define **aparência**. O P1 define **geometria**.

A arte é normalizada para o rig. O rig não é derivado de um crop da arte e não é alterado por personagem.

## 2. Canvas canônico

- Assembly canvas: `512×512`
- Center axis: `x=256`
- Ground line: `y=448`
- Character visual top target: `y≈90`
- Character visual height target: `≈358 px`
- Hip/root locomotor: `(256,326)`

## 3. Joints / markers canônicos

| Marker | X | Y | Função |
|---|---:|---:|---|
| `HEAD_CENTER` | 256 | 145 | centro visual da cabeça |
| `HEAD_ROOT` | 256 | 194 | pivot cabeça/pescoço |
| `SHOULDER_L` | 215 | 232 | pivot braço superior esquerdo |
| `SHOULDER_R` | 297 | 232 | pivot braço superior direito |
| `ELBOW_L` | 190 | 276 | pivot antebraço esquerdo |
| `ELBOW_R` | 322 | 276 | pivot antebraço direito |
| `HAND_L` | 174 | 322 | mão/offhand socket |
| `HAND_R` | 338 | 322 | mão/weapon socket |
| `HIP` | 256 | 326 | root locomotor |
| `KNEE_L` | 228 | 382 | pivot perna inferior esquerda |
| `KNEE_R` | 284 | 382 | pivot perna inferior direita |
| `FOOT_L` | 220 | 448 | contato com chão esquerdo |
| `FOOT_R` | 292 | 448 | contato com chão direito |

## 4. Bone hierarchy

```text
root
└── hip
    ├── torso
    │   ├── head
    │   ├── upper_arm_l
    │   │   └── forearm_hand_l
    │   └── upper_arm_r
    │       └── forearm_hand_r
    ├── thigh_l
    │   └── lower_leg_boot_l
    └── thigh_r
        └── lower_leg_boot_r
```

No piloto, mão pode permanecer integrada ao asset de antebraço. Não há finger bones.

## 5. Secondary sockets

- `WEAPON_MAIN`: parent `forearm_hand_r`; socket nominal = `HAND_R`; grip offset vem do weapon asset.
- `OFFHAND`: parent `forearm_hand_l`; socket nominal = `HAND_L`; grip/brace offsets vêm do shield asset.
- `BACK_CAPE`: parent torso; attachment específico declarado no cape asset.
- `CHEST_ACCESSORY`: parent torso.
- `WAIST_ACCESSORY`: parent hip.
- `FX_ORIGIN`: default hip; clips podem definir outro socket.

## 6. Views

Author exactly:
- `FRONT_3Q`
- `BACK_3Q`

Facing horizontal usa mirror somente quando o asset/família declara `mirror_safe=true`.

As duas views compartilham:
- canvas;
- joints;
- hierarchy;
- nomes;
- animation semantics.

A arte muda. O esqueleto não.

## 7. Pivot policy

Pivots são anatômicos/semânticos:

- head → `HEAD_ROOT`
- upper arm → shoulder
- forearm/hand → elbow
- thigh → hip
- lower leg/boot → knee
- weapon → grip
- shield → grip + optional brace point

Nunca usar automaticamente o centro do bounding box do PNG.

## 8. Trim reconstruction invariant

Todo source asset é criado/alinhado no canvas 512.

Se depois for trimado:
1. guardar `source_canvas_size`;
2. guardar `canvas_offset`;
3. guardar pivot em source coordinates ou pivot local + offset;
4. reconstruir no rig;
5. comparação pixel/overlay deve retornar à mesma pose.

Um trim que causa drift reprova o asset.

## 9. Armor-set rule

`armor_set` continua sendo uma escolha procedural única que referencia:

- torso;
- upper_arm_l/r;
- forearm_hand_l/r;
- thigh_l/r;
- lower_leg_boot_l/r;
- waist/tabard when applicable.

O RNG não mistura subpeças de armor sets diferentes.

## 10. P2 acceptance prerequisite

Antes de Swap Test, `armor_blackguard_01` deve:

- encaixar na rest pose P1 v2 em ambas views;
- rotacionar nos pivots sem articulação visual quebrada;
- manter boots ligados às pernas;
- manter ombros dentro da silhueta;
- preservar sword/shield sockets;
- exigir zero alteração no shared rig.

Somente então geramos `armor_fallen_paladin_01` e as variantes do Swap Test.
