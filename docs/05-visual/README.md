# Visual

A direção macro já aprovada está em `VISUAL_DIRECTION_BRIEF.md`.

Próximos documentos a criar nesta pasta:

- `VISUAL_BIBLE.md` — direção completa de arte, UI, inimigos, Base, Torre e apresentação;
- `GOLDEN_RIG.md` — especificação final do rig modular e pipeline de assets;
- `ASSET_CATALOG.md` — inventário de assets necessários para o Vertical Slice.

Esses arquivos ainda não devem ser preenchidos por agentes sem uma fase explícita de design visual.

## Contratos do Golden Rig (P1.5) — adicionados em 2026-09-18

Fonte de verdade do rig modular (não medir anchors da arte; não inventar bones):

- `P1_VANGUARD_RIG_SPEC_v2.md` — geometria canônica P1 v2;
- `agent-contract/P1_5_GOLDEN_RIG_AGENT_CONTRACT.md` — precedência e responsabilidades dos agentes;
- `agent-contract/GODOT_SCENE_CONTRACT.md` — árvore de cena canônica;
- `agent-contract/GOLDEN_RIG_LAB.md` — capacidades obrigatórias do Lab e gates;
- `agent-contract/ANIMATION_SEMANTICS.md`, `agent-contract/VALIDATION_RULES.md`;
- `agent-contract/manifests/vanguard_sword_shield.rig.json` — manifest P1.5 congelado (bones, sockets, z-lanes).

Gate P2.4B (Blackguard FRONT_3Q): `p2_4b/` contém o brief, a spec, o audit, o manifest de candidatos e o
relatório da primeira montagem (`P2_4B_0_LAB_REPORT.md`, screenshots em `review_p2_4b_0/`).

Implementação do Lab: `sandbox/golden_rig_lab/` (projeto Godot isolado; ver README lá).
