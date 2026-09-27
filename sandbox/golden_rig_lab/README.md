# Golden Rig Lab — sandbox (P2.4B-0)

Bancada visual isolada para o rig compartilhado `VANGUARD_SWORD_SHIELD` (P1.5 congelado).
Projeto Godot 4.7 independente: **não contém e não depende de nenhum código de gameplay**.

Contratos que este sandbox implementa (fonte de verdade em `docs/05-visual/`):

- `agent-contract/P1_5_GOLDEN_RIG_AGENT_CONTRACT.md`
- `agent-contract/GODOT_SCENE_CONTRACT.md` — árvore de cena canônica
- `agent-contract/GOLDEN_RIG_LAB.md` — capacidades obrigatórias do Lab
- `agent-contract/VALIDATION_RULES.md` — códigos GRxxx
- `agent-contract/manifests/vanguard_sword_shield.rig.json` — anchors/bones/sockets/z-lanes

`contracts/manifests/vanguard_sword_shield.rig.json` é uma **cópia byte a byte** do manifest em `docs/`.
Se o manifest canônico mudar, copie de novo; nunca edite a cópia.

## Estrutura

```text
project.godot
contracts/manifests/vanguard_sword_shield.rig.json   # cópia do manifest P1.5 (read-only)
rig/
  rig_manifest.gd        # loader read-only do manifest + checagens GR020/GR021/GR022
  rig_builder.gd         # constrói/verifica Skeleton2D/Bone2D a partir do manifest (GR022/GR023)
  visual_part.gd         # metadata por peça + invariante de placement (único lugar)
  visual_assembler.gd    # caminho de produção: anexa peças por metadata, z absoluto, mirror policy
  rig_validator.gd       # GRxxx automatizáveis + diagnósticos LAB0x de encaixe
scenes/
  vanguard_sword_shield_appearance.tscn  # GERADA por tools/generate_appearance_scene.gd
  vanguard_sword_shield_appearance.gd    # verifica o rig contra o manifest ao carregar
  debug_overlay.gd                        # canvas, eixo, chão, bones, joints, sockets, labels, z
  golden_rig_lab.tscn / .gd               # a bancada (UI + export)
tools/generate_appearance_scene.gd        # gera a cena canônica (bones só do manifest)
assets/armor/armor_blackguard_01/front_3q/*.png   # 10 PNGs P2.4B, inalterados (sha256 idêntico ao pacote)
metadata/armor_sets/armor_blackguard_01.armor_set.json
metadata/parts/armor_blackguard_01/<slot>.visual_part.json   # pivot / canvas_offset / scale / z por view
screenshots/                               # saída dos exports
```

## Como rodar

```powershell
$GODOT = "C:\Users\mateu\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe"
cd C:\DEV\Jogo\spirewake\sandbox\golden_rig_lab

# 1. importar assets (primeira vez / após adicionar PNGs)
& $GODOT --headless --path . --import

# 2. (re)gerar a cena canônica a partir do manifest
& $GODOT --headless --path . -s tools/generate_appearance_scene.gd

# 3. abrir o Lab
& $GODOT --path .

# 4. exportar o conjunto completo de screenshots P2.4B-0 e sair
& $GODOT --path . -- --capture
```

## Regras respeitadas

- Bones, rest transforms, sockets e z-lanes vêm **apenas** do manifest. Nenhum valor é medido da arte.
- Toda correção de peça é feita em `metadata/parts/**` (pivot_source, canvas_offset, scale_to_logical, z_index).
- `sprite_local_position = (texture_size/2 - (pivot_source - canvas_offset)) * scale`
  (generalização do invariante `(256,256) - pivot_source` para candidatos brutos e texturas trimadas).
- Todo Sprite2D modular usa `z_as_relative = false` com `z_index` absoluto da metadata.
- Mirror (facing esquerda) só é aplicado se **todas** as peças forem `mirror_safe`; senão é recusado.
- BACK_3Q, animação e gameplay estão desabilitados neste gate.
