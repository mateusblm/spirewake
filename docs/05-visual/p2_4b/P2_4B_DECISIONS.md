# P2.4B — Decisões congeladas

**Data:** 2026-09-18
**Escopo:** pipeline visual do Golden Rig / `armor_blackguard_01`. Não altera nenhum documento de gameplay.

## Gate P2.4B-0 — Golden Rig Lab

- **APROVADO e congelado** em 2026-09-18 (`sandbox/golden_rig_lab/`, relatório `P2_4B_0_LAB_REPORT.md`).
- O rig P1.5 (`agent-contract/manifests/vanguard_sword_shield.rig.json`) permanece intacto: anchors, bones, sockets, hierarquia, rest transforms e contratos não mudam em nenhum pass de correção de arte.

## Set `armor_blackguard_01` / FRONT_3Q

- **NÃO aprovado.** Aberto o pass de correção de arte **P2.4B-1** (ver `P2_4B_1_REGENERATION_BRIEF.md`).

| # | Decisão | Status |
|---|---|---|
| D1 | Rotação local por asset na metadata (`rest_rotation_offset_deg`) | **Rejeitada nesta fase.** Correção via regeneração da arte no ângulo do rest pose. |
| D2 | Lado near em FRONT_3Q facing right | **Lado direito (R)**: `upper_arm_r`/`forearm_hand_r` na lane `armor_near` (85/86); `_l` na lane `armor_far` (30/31). |
| D3 | z do `waist_tabard` | **51** (mantido). |
| D4 | `forearm_hand_l` / `forearm_hand_r` | **Regenerar como PNG RGBA real, com transparência verdadeira.** Os arquivos entregues (JPEG com extensão .png) estão reprovados. |
| D5 | Dono da cintura em v1 | **Torso.** `waist_tabard` contém apenas a parte pendurada (cloth/faulds), **sem cinto**. |
| D6 | Auditoria de assets | Checar assinatura do arquivo e canal alpha real, não a extensão (`tools/intake_check.py`). |

## Slots do pass P2.4B-1

| Regenerar (FRONT_3Q) | Manter |
|---|---|
| `upper_arm_l`, `upper_arm_r`, `forearm_hand_l`, `forearm_hand_r`, `thigh_l`, `thigh_r`, `waist_tabard` | `torso`, `lower_leg_boot_l`, `lower_leg_boot_r` |

Após a entrega dos 7 PNGs: rodar o mesmo Lab, exportar o mesmo pacote de screenshots e gerar o relatório comparativo antes/depois (`tools/compare_validation.py`).
