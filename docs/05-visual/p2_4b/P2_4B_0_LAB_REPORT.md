# P2.4B-0 — Golden Rig Lab: implementação e primeira montagem FRONT_3Q

**Data:** 2026-09-18
**Arquétipo:** `VANGUARD_SWORD_SHIELD` (rig P1.5 `frozen_p1_5`)
**Armor set:** `armor_blackguard_01` / `FRONT_3Q` / facing `right`
**Status do Lab:** implementado, aguardando review
**Status da montagem P2.4B:** **NÃO APROVADA** — 10/10 peças carregam, mas 6 slots não encaixam sem alteração do asset (detalhe na seção 6)
**Shared rig:** nenhum anchor, bone, socket ou hierarquia foi alterado. Todas as correções vivem em `metadata/parts/**`.

---

## 1. Arquivos criados / modificados

### Documentação (repo)

| Caminho | Origem |
|---|---|
| `docs/05-visual/P1_VANGUARD_RIG_SPEC_v2.md` | pacote `spirewake_golden_rig_lab_required_files_v1.zip` |
| `docs/05-visual/agent-contract/P1_5_GOLDEN_RIG_AGENT_CONTRACT.md` | idem |
| `docs/05-visual/agent-contract/GODOT_SCENE_CONTRACT.md` | idem |
| `docs/05-visual/agent-contract/GOLDEN_RIG_LAB.md` | idem |
| `docs/05-visual/agent-contract/ANIMATION_SEMANTICS.md` | idem |
| `docs/05-visual/agent-contract/VALIDATION_RULES.md` | idem |
| `docs/05-visual/agent-contract/manifests/vanguard_sword_shield.rig.json` | idem (sha256 `2ddf79d1…58e7`) |
| `docs/05-visual/p2_4b/AGENT_BRIEF_P2_4B.md`, `P2_4B_REAL_REASSEMBLY_SPEC.md`, `ASSET_AUDIT.md`, `P2_4B_front3q_candidate_manifest.json` | pacote `spirewake_P2_4B_blackguard_front3q_real_reassembly.zip` |
| `docs/05-visual/p2_4b/P2_4B_0_LAB_REPORT.md` | este relatório |
| `docs/05-visual/p2_4b/review_p2_4b_0/*.png, *.txt` | screenshots exportados pelo Lab (17 arquivos) |
| `docs/05-visual/README.md` | seção nova apontando para os contratos e o sandbox |
| `docs/00-governance/CHANGELOG.md` | entrada 0.4.1 |

### Sandbox Godot (`sandbox/golden_rig_lab/`, projeto isolado, sem gameplay)

| Caminho | Papel |
|---|---|
| `project.godot`, `.gitignore`, `README.md` | projeto Godot 4.7.2, renderer `gl_compatibility` |
| `contracts/manifests/vanguard_sword_shield.rig.json` | cópia byte a byte do manifest (read-only) |
| `rig/rig_manifest.gd` | loader read-only + checagens GR001/GR020/GR021/GR022 de autoconsistência |
| `rig/rig_builder.gd` | constrói e **verifica** `Skeleton2D/Bone2D` + sockets a partir do manifest (GR020/GR022/GR023); `apply_rest_pose()` |
| `rig/visual_part.gd` | metadata por peça/view; único lugar com o invariante de placement |
| `rig/visual_assembler.gd` | caminho de produção: anexa peças por metadata, `z_as_relative=false`, z absoluto, política de mirror |
| `rig/rig_validator.gd` | GR003/GR010/GR011/GR012/GR013/GR020/GR022/GR023/GR024/GR030/GR031/GR052 automatizáveis + diagnósticos `LAB01..03` |
| `scenes/vanguard_sword_shield_appearance.tscn` | **gerada** por `tools/generate_appearance_scene.gd` (não editada à mão) |
| `scenes/vanguard_sword_shield_appearance.gd` | verifica o rig contra o manifest ao carregar; `AnimationTree.active=false` |
| `scenes/debug_overlay.gd` | canvas 512, eixo, chão, bones, joints, pivots secundários, sockets, view, slot names, z absoluto |
| `scenes/golden_rig_lab.tscn` + `.gd` | a bancada: UI, modos Geometry/Art/Z-order, inspector de metadata, export |
| `tools/generate_appearance_scene.gd` | gera a cena canônica (bones/sockets só do manifest; nomes/ordem só do scene contract) |
| `assets/armor/armor_blackguard_01/front_3q/*.png` | 8 PNGs P2.4B, byte-idênticos ao pacote |
| `assets/armor/armor_blackguard_01/front_3q/*.jpg` | 2 antebraços: **cópias byte-idênticas** dos arquivos entregues, renomeadas (ver 6.1) |
| `assets/armor/armor_blackguard_01/front_3q/_source_as_delivered/` | os 2 antebraços exatamente como entregues (`.gdignore`) |
| `metadata/armor_sets/armor_blackguard_01.armor_set.json` | set atômico: 10 slots obrigatórios → part files |
| `metadata/parts/armor_blackguard_01/<slot>.visual_part.json` | pivot_source / canvas_offset / scale_to_logical / z_index por view |

Nenhum PNG foi editado. Nenhum arquivo fora de `docs/05-visual/`, `docs/00-governance/CHANGELOG.md` e `sandbox/` foi tocado.

---

## 2. Estrutura da cena (gerada, verificada em runtime)

```text
VanguardSwordShieldAppearance (Node2D)
├── ContactShadow (Sprite2D)                       # (256,448) sem textura
├── MirrorRoot (Node2D)                            # position=(256,0), scale.x=±1
│   └── Skeleton2D
│       └── hip (Bone2D)  rest=(0,326)
│           ├── waist_tabard (Sprite2D)            # "waist_tabard é filho de hip"
│           ├── torso (Bone2D)  rest=(0,0) len=132
│           │   ├── body_torso, armor_torso, cape_back, chest_accessory (Sprite2D)
│           │   ├── head (Bone2D)  rest=(0,-132) len=49
│           │   │   └── head_base, face_overlay, scar_overlay, hair_back, hair_front, head_accessory
│           │   ├── upper_arm_l (Bone2D)  rest=(-41,-94) len=50.6
│           │   │   ├── body_upper_arm_l, armor_upper_arm_l
│           │   │   └── forearm_hand_l (Bone2D)  rest=(-25,44) len=48.7
│           │   │       ├── body_forearm_hand_l, armor_forearm_hand_l
│           │   │       └── offhand_socket (Marker2D) (-16,46) └── offhand (Sprite2D)
│           │   ├── upper_arm_r (Bone2D)  rest=(41,-94) len=50.6
│           │   │   ├── body_upper_arm_r, armor_upper_arm_r
│           │   │   └── forearm_hand_r (Bone2D)  rest=(25,44) len=48.7
│           │   │       ├── body_forearm_hand_r, armor_forearm_hand_r
│           │   │       └── weapon_main_socket (Marker2D) (16,46) └── weapon_main (Sprite2D)
│           │   ├── back_cape_socket (Marker2D) (0,-82)
│           │   └── chest_accessory_socket (Marker2D) (0,-76)
│           ├── thigh_l (Bone2D)  rest=(-20,0) len=56.6
│           │   ├── body_thigh_l, armor_thigh_l
│           │   └── lower_leg_boot_l (Bone2D)  rest=(-8,56) len=66.5
│           │       └── body_lower_leg_l, armor_lower_leg_boot_l
│           ├── thigh_r (Bone2D)  rest=(20,0) len=56.6
│           │   ├── body_thigh_r, armor_thigh_r
│           │   └── lower_leg_boot_r (Bone2D)  rest=(8,56) len=66.5
│           │       └── body_lower_leg_r, armor_lower_leg_boot_r
│           ├── waist_accessory_socket (Marker2D) (0,4)
│           └── fx_origin_socket (Marker2D) (0,0)
├── AnimationPlayer
├── AnimationTree                                  # active=false
├── VisualAssembler (Node)
└── DebugOverlay (Node2D)                          # z_index absoluto 4000
```

Verificação em runtime (`RigBuilder.verify`): **OK, 0 erros** — todos os 11 bones com pai e rest transform iguais ao manifest, 6 sockets nas posições do manifest, nenhum `Bone2D` extra (GR023).

---

## 3. Como reproduzir

```powershell
$GODOT = "C:\Users\mateu\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe"
cd C:\DEV\Jogo\spirewake\sandbox\golden_rig_lab
& $GODOT --headless --path . --import                                # importar assets
& $GODOT --headless --path . -s tools/generate_appearance_scene.gd   # regerar cena canônica
& $GODOT --path .                                                    # abrir o Lab
& $GODOT --path . -- --capture                                       # exportar os 17 arquivos de review
```

Capacidades entregues neste gate (GOLDEN_RIG_LAB.md §1, lista obrigatória de P2.4B-0):

| Capacidade | Estado |
|---|---|
| View FRONT_3Q | ✅ (BACK_3Q aparece no seletor, desabilitado) |
| Facing Direita/Esquerda | ✅ seletor; "Esquerda" é **recusado** porque nenhuma peça é `mirror_safe` (política do scene contract) |
| Rest pose | ✅ `apply_rest()` em todos os bones; sem animação |
| Carregar os 10 PNGs por metadata | ✅ |
| Toggle bones / pivots+sockets / canvas 512 / z labels | ✅ |
| Controlar pivot, canvas_offset, scale, z_index por metadata | ✅ inspector por slot com save em JSON |
| Screenshot composite limpo | ✅ `__art.png` (1024, 2× lógico) + `__art__1x.png` (512, escala lógica) |
| Screenshot com overlay técnico | ✅ `__geometry.png`, `__zorder.png`, closeups |
| Sem lógica de combate | ✅ o projeto não tem nenhum código de gameplay |

---

## 4. Metadata por slot (primeira passagem)

Método: para cada peça, o pivot é o ponto anatômico proximal identificado na arte (cotovelo, ombro, aro superior, centro do cinto) e a escala é `comprimento_do_bone / distância_na_arte(pivot, articulação distal)`. Os anchors do rig **não** foram medidos da arte; só a posição do pivot **dentro da arte** foi determinada visualmente e por extensão de alpha por linha. Os valores estão nos JSON com `notes` explicando a derivação.

| slot | bone | pivot_source (px) | distal_source → marker | scale | z | lane |
|---|---|---|---|---:|---:|---|
| torso | torso | (640, 1202) | (959, 450) → SHOULDER_R | 0.1250 | 50 | torso |
| upper_arm_l | upper_arm_l | (650, 330) | (700, 1030) → ELBOW_L | 0.0721 | 30 | armor_far |
| upper_arm_r | upper_arm_r | (615, 330) | (570, 1030) → ELBOW_R | 0.0722 | 85 | armor_near |
| forearm_hand_l | forearm_hand_l | (470, 290) | (970, 1180) → HAND_L | 0.0477 | 31 | armor_far |
| forearm_hand_r | forearm_hand_r | (540, 320) | (980, 1180) → HAND_R | 0.0504 | 86 | armor_near |
| thigh_l | thigh_l | (640, 220) | (755, 1080) → KNEE_L | 0.0652 | 40 | legs |
| thigh_r | thigh_r | (640, 215) | (515, 1080) → KNEE_R | 0.0648 | 42 | legs |
| lower_leg_boot_l | lower_leg_boot_l | (655, 190) | (560, 1236) → FOOT_L | 0.0633 | 41 | legs |
| lower_leg_boot_r | lower_leg_boot_r | (620, 185) | (720, 1159) → FOOT_R | 0.0679 | 43 | legs |
| waist_tabard | hip | (632, 290) | — | 0.1400 | 51 | torso+1 |

Invariante aplicado pelo assembler: `position = (texture_size/2 − (pivot_source − canvas_offset)) × scale`, que se reduz a `(256,256) − pivot_source` para as texturas 512 normalizadas do contrato.

---

## 5. Screenshots (`docs/05-visual/p2_4b/review_p2_4b_0/`)

| Exigido (GOLDEN_RIG_LAB.md §7) | Arquivo |
|---|---|
| 1. Lab aberto | `blackguard_p2_4b__front3q__right__lab_open.png` |
| 2. Rig vazio com bones + pivots | `blackguard_p2_4b__front3q__right__rig_empty__geometry.png` |
| 3. Reconstrução FRONT_3Q completa | `…__geometry.png` (overlay), `…__art.png` (limpo, 2×), `…__art__1x.png` (512), `…__zorder.png` |
| 4. Closeup ombro/cotovelo L | `…__closeup_shoulder_elbow_l__geometry.png` / `__art.png` |
| 5. Closeup ombro/cotovelo R | `…__closeup_shoulder_elbow_r__geometry.png` / `__art.png` |
| 6. Closeup quadril/joelho/bota L | `…__closeup_hip_knee_boot_l__geometry.png` / `__art.png` |
| 7. Closeup quadril/joelho/bota R | `…__closeup_hip_knee_boot_r__geometry.png` / `__art.png` |
| 8. Closeup cintura/tabard | `…__closeup_waist_tabard__geometry.png` / `__art.png` |
| Relatório do validador | `blackguard_p2_4b__front3q__right__validation.txt` |

Os enquadramentos dos closeups são derivados dos markers do manifest (ponto médio SHOULDER→ELBOW, HIP_x→FOOT_x, HIP), não da arte.

---

## 6. Relatório de mismatch (formato P2_4B_REAL_REASSEMBLY_SPEC §D)

Diagnóstico numérico reproduzível (`LAB01`): distância entre onde a articulação distal da arte cai e o marker congelado, com a peça escalada para o comprimento exato do bone.

| slot | drift no marker distal | ângulo arte × bone |
|---|---:|---:|
| torso → SHOULDER_R | 1.1 px | −0.6° |
| upper_arm_l → ELBOW_L | **29.3 px** | **−33.7°** |
| upper_arm_r → ELBOW_R | **29.0 px** | **+33.3°** |
| forearm_hand_l → HAND_L | **40.0 px** | **−48.5°** |
| forearm_hand_r → HAND_R | 6.7 px | −7.9° |
| thigh_l → KNEE_L | **15.5 px** | **−15.7°** |
| thigh_r → KNEE_R | **16.1 px** | **+16.4°** |
| lower_leg_boot_l → FOOT_L | 2.0 px | −1.7° |
| lower_leg_boot_r → FOOT_R | 1.2 px | +1.0° |

### 6.1 forearm_hand_l e forearm_hand_r — REPROVADOS (GR012)

```text
slot: forearm_hand_l, forearm_hand_r
problem: os dois arquivos entregues como .png são JPEG/JFIF (assinatura ffd8ffe0), modo RGB, sem canal alpha,
         fundo preto opaco 1536×1536. O manifest de candidatos declara has_alpha=true e alpha_bbox=canvas inteiro:
         a informação está errada. O importador do Godot recusa o arquivo com extensão .png; o Lab carrega uma
         cópia byte-idêntica renomeada para .jpg apenas para que a montagem mostre os 10 slots (o quadrado preto
         nos screenshots é o próprio asset). Além disso forearm_hand_l está desenhado descendo para a direita
         (~29° da vertical) enquanto o bone ELBOW_L→HAND_L desce para a esquerda (~19°): 48.5° de diferença,
         a mão cai 40 px longe de HAND_L. forearm_hand_r tem eixo aceitável (7.9°, 6.7 px).
asset-local fix possible? yes — regenerar como PNG RGBA (forearm_hand_l também no ângulo do bone)
metadata-only fix possible? no — metadata não cria canal alpha
would require shared-rig exception? no
```

### 6.2 upper_arm_l e upper_arm_r — REPROVADOS (cotovelo quebrado)

```text
slot: upper_arm_l, upper_arm_r
problem: a arte de ambos os braços superiores está desenhada praticamente vertical (≈4° da vertical, ligeiramente
         para dentro), enquanto o rest pose P1 v2 tem SHOULDER→ELBOW a 29.6° para fora. Com a escala que faz o
         comprimento bater (50.6 px) o punho do braço superior termina ~29 px longe do ELBOW: o antebraço
         encaixa no ar (visível em closeup_shoulder_elbow_r) ou atrás do torso (lado L). Alpha toca a borda
         inferior do canvas (GR052): o punho do cotovelo está cortado no source.
asset-local fix possible? yes — regenerar com o braço no ângulo do bone (ou com o punho do cotovelo dentro do canvas)
metadata-only fix possible? no com o contrato atual (não existe rotação local por asset em P1.5/P2.4B);
                            seria possível SE for aprovado um campo `rest_rotation_offset_deg` na metadata (decisão D1)
would require shared-rig exception? no
```

### 6.3 thigh_l e thigh_r — REPROVADOS (joelho deslocado; mascarado pelo tabard)

```text
slot: thigh_l, thigh_r
problem: coxas desenhadas convergindo para dentro (~8° para o centro) enquanto o rig diverge 8° para fora:
         16° de diferença, o punho do joelho cai 15–16 px para dentro do KNEE. O aro superior da bota (no KNEE)
         fica deslocado do punho da coxa; hoje isso quase não aparece porque o tabard cobre os joelhos.
         Alpha toca a borda inferior (GR052): o punho do joelho está cortado no source.
asset-local fix possible? yes — regenerar no ângulo do bone e com o punho inteiro dentro do canvas
metadata-only fix possible? no (mesma dependência da decisão D1)
would require shared-rig exception? no
```

### 6.4 waist_tabard — REPROVADO (proporção)

```text
slot: waist_tabard
problem: com o cinto na largura do quadril (~80 px lógicos) o pano termina em y=461, 13 px abaixo do ground_y=448
         (LAB02), e cobre joelhos e cano das botas; alpha cortada na borda inferior (GR052). Reduzir a escala para
         o pano terminar acima do chão deixa o cinto mais estreito que o quadril (deformação não uniforme é proibida).
         O cinto do tabard fica 44 px abaixo do cinto que já existe no torso: leitura de "cinto duplo" (closeup_waist_tabard).
asset-local fix possible? yes — regenerar mais curto (pano até ~meio da canela) e sem cinto, ou decidir que o torso
                          não deve ter cinto/tassets próprios (decisão D5)
metadata-only fix possible? partial — só trocando um problema por outro (escala)
would require shared-rig exception? no
```

### 6.5 torso — OK geometricamente, com ressalva

```text
slot: torso
problem: encaixa (ombros a 1.1 px dos markers, colar sob HEAD_ROOT, base do pano na linha do quadril). Ressalvas:
         inclui cinto + tassets + pano próprios que colidem com waist_tabard (cinto duplo); alpha toca a borda
         esquerda (GR052, 1 px). Ombros do torso ficam ~13 px mais largos que SHOULDER_L/R (aceitável: o pivot
         fica dentro da ombreira).
asset-local fix possible? yes (se o cinto duplo for rejeitado)
metadata-only fix possible? n/a
would require shared-rig exception? no
```

### 6.6 lower_leg_boot_l e lower_leg_boot_r — OK

Encaixam (drift 2.0 / 1.2 px, eixo dentro de 2°); botas tocam o chão em FOOT_L/FOOT_R. Nota de design apenas: a bota L está desenhada com a ponta para a esquerda da tela (postura aberta), a R para a direita.

### 6.7 Global

- `GR011` nos 10 slots: os candidatos são 1254×1254 / 1536×1536 brutos, não PNGs normalizados 512×512. Aceito neste gate porque a spec P2.4B permite "asset-local scale normalization"; o congelamento `armor_blackguard_01 / FRONT_3Q / v1` precisa produzir os 10 PNGs 512 normalizados (ou aprovar o trim compiler com `canvas_offset`).
- `GR010` back_3q ausente nos 10 slots: esperado (P2.4C).
- Critérios de aceite P2.4B: "10/10 montam" ✅ (carregam e anexam); "nenhuma articulação quebrada" ❌; "botas conectam" ✅; "tabard sobre as coxas de forma limpa" ❌; "cotovelos sem gap" ❌; "rig não movido" ✅; "correção reproduzível por metadata" ✅; "silhueta lê como Blackguard" ⚠️ parcial (composição geral sim; antebraços pretos e braços verticais não).

---

## 7. Decisões pendentes (não foram tomadas por mim)

| # | Decisão | Por que importa |
|---|---|---|
| D1 | Aprovar (ou não) um campo `rest_rotation_offset_deg` por asset/view na metadata | Sem ele, braços e coxas só encaixam por regeneração da arte no ângulo do rest pose. Com ele, 4 slots viram correção de metadata. Não está no contrato P1.5; não implementei. |
| D2 | Qual lado é "near" em FRONT_3Q facing right | Assumi **R = near** (lado da arma, `armor_near` 85/86) e **L = far** (`armor_far` 30/31). O manifest não diz. |
| D3 | z do `waist_tabard` | Usei 51 (lane `torso` + 1, sobre o torso e as pernas, sob o braço near). A lane `accessory` (100) o colocaria sobre o braço near. |
| D4 | Regenerar os dois antebraços como PNG RGBA | Bloqueante para P2.4B. |
| D5 | Quem é dono da cintura: torso (cinto+tassets já inclusos) ou `waist_tabard` | Hoje há dois cintos empilhados. |
| D6 | Auditoria de assets deve checar assinatura do arquivo, não só a extensão | O manifest de candidatos afirmou alpha em arquivos JPEG. |

---

## 8. Critérios de aceite do Lab (GOLDEN_RIG_LAB.md §9)

| Critério | Estado |
|---|---|
| deriva bones/rest transforms do manifest | ✅ gerador + verificação runtime |
| nenhum anchor "a olho" da arte | ✅ (só pivots internos das peças, por metadata) |
| 10 assets FRONT_3Q carregam independentemente | ✅ (cada slot é um `visual_part.json`) |
| transforms dos slots vivem em metadata, não em edições de cena | ✅ a `.tscn` não contém texturas nem posições de sprite |
| screenshots clean/debug reproduzíveis | ✅ `-- --capture` |
| nenhum código de gameplay necessário | ✅ |

## 9. Fora de escopo neste gate (não implementado, por instrução)

BACK_3Q (seletor desabilitado), animações (`AnimationPlayer` vazio, `AnimationTree` inativo), catálogo Golden DNA / VisualDNA, Swap Test fixtures, trim/atlas compiler, sombra de contato (sprite sem textura), body/skin/hair/weapon/shield (sprites vazios já existem na cena conforme o contrato).
