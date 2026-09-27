# P2.4B-1 — Brief de regeneração de arte (armor_blackguard_01 / FRONT_3Q)

**Data:** 2026-09-18
**Rig:** `vanguard_sword_shield` P1.5 congelado. **Nada do rig muda.** Este pass corrige só a arte.
**Decisões aplicadas:** `P2_4B_DECISIONS.md` (D1 rejeitada, D2 near = direito, D3 z=51, D4 PNG RGBA real, D5 torso é dono da cintura).
**Quem executa a geração:** ChatGPT / geração de imagem (P1_5_GOLDEN_RIG_AGENT_CONTRACT: "source asset generation/refinement"). Claude não gera raster; Claude monta, valida e reporta.

## 1. Regra de entrega (vale para os 7 slots)

1. **Pintar a peça sobre o template do slot** em `regen_templates_p2_4b_1/regen_template__<slot>__front3q__2x.png` (1024×1024 = 2× o canvas lógico 512) ou na versão `3x` (1536×1536). O template mostra o torso e as botas mantidos, todos os bones em cinza, o bone do slot em amarelo e as duas articulações em vermelho com as coordenadas.
2. **Entregar PNG RGBA real** (assinatura PNG, modo RGBA), fundo 100% transparente, sem halo preto/branco, cantos do canvas transparentes. Nada de JPEG renomeado.
3. **Mesmo tamanho do template** usado: 1024×1024 ou 1536×1536. Não recortar, não reposicionar depois de pintar.
4. **A articulação proximal da peça deve cobrir o círculo vermelho proximal e a distal o círculo distal.** É isso que faz a peça encaixar sem rotação: o braço/coxa é desenhado já no ângulo do bone.
5. **Peça inteira dentro do canvas**: alpha não pode tocar as bordas (GR052). Punhos de cotovelo/joelho completos.
6. Estilo, materiais e paleta iguais aos assets mantidos (torso, botas): couro preto, metal escuro com filetes dourados, vermelho escuro, cruz dourada.
7. Não incluir partes de outros slots (o braço superior não traz antebraço; a coxa não traz bota; o tabard não traz cinto).

Ao seguir o template, a metadata fica trivial e é proposta automaticamente por `tools/intake_check.py`:
`pivot_source = marker × k`, `scale_to_logical = 1/k`, `canvas_offset = [0,0]`.

## 2. Especificação por slot

Coordenadas em px lógicos (canvas 512). Em template 2× multiplicar por 2; em 3× por 3.
Ângulo medido a partir da vertical, positivo para a direita da tela.

| slot | bone | proximal (pivot) | distal | comprimento | ângulo | z | lane |
|---|---|---|---|---:|---:|---:|---|
| `upper_arm_l` | upper_arm_l | SHOULDER_L (215,232) | ELBOW_L (190,276) | 50.6 | −29.6° | 30 | armor_far, **atrás** do torso |
| `upper_arm_r` | upper_arm_r | SHOULDER_R (297,232) | ELBOW_R (322,276) | 50.6 | +29.6° | 85 | armor_near, **na frente** do torso |
| `forearm_hand_l` | forearm_hand_l | ELBOW_L (190,276) | HAND_L (174,322) | 48.7 | −19.2° | 31 | armor_far |
| `forearm_hand_r` | forearm_hand_r | ELBOW_R (322,276) | HAND_R (338,322) | 48.7 | +19.2° | 86 | armor_near |
| `thigh_l` | thigh_l | HIP_L (236,326) | KNEE_L (228,382) | 56.6 | −8.1° | 40 | legs |
| `thigh_r` | thigh_r | HIP_R (276,326) | KNEE_R (284,382) | 56.6 | +8.1° | 42 | legs |
| `waist_tabard` | hip | HIP (256,326) | — | — | — | 51 | sobre torso e pernas, sob o braço near |

### upper_arm_l / upper_arm_r
- Ombreira (pauldron) centrada sobre SHOULDER; o cilindro do braço desce **para fora** até o punho do cotovelo centrado em ELBOW.
- O que falhou antes: braço desenhado vertical (33° fora do bone) e punho do cotovelo cortado pela borda.
- O `_l` fica atrás do torso: só a ombreira e a borda externa aparecem. O `_r` fica na frente e cobre a ombreira que o torso já tem.
- Largura de referência: o punho do cotovelo deve caber dentro do punho superior do antebraço (ver abaixo).

### forearm_hand_l / forearm_hand_r
- Punho superior (abertura do cotovelo) centrado em ELBOW; punho fechado (luva) centrado em HAND, que é o socket de arma/escudo. O grip da arma futura sai de HAND_R; o escudo de HAND_L.
- O que falhou antes: arquivo JPEG sem alpha; `_l` desenhado descendo para a **direita** (48° fora); deve descer para a **esquerda** como o bone.
- Mão integrada ao antebraço (sem finger bones, P1 v2 §4).

### thigh_l / thigh_r
- Aro superior da coxa centrado em HIP_L / HIP_R (fica sob o pano do torso e do tabard); punho do joelho centrado em KNEE_L / KNEE_R, completo dentro do canvas.
- O que falhou antes: coxas convergindo para dentro (16° fora) e punho do joelho cortado.
- Largura de referência: o aro superior da bota (mantida) está no joelho com ~34 px lógicos de largura; o punho da coxa deve encaixar por cima/dentro dele.

### waist_tabard
- **Só cloth/faulds pendurados, sem cinto e sem fivela.** O torso mantido já tem cinto, tassets e o início do pano.
- Borda superior na linha do quadril y=326 (fica escondida sob o cinto do torso); ponto de fixação HIP (256,326).
- Comprimento: terminar **acima de y≈422** (meio da canela). Nunca abaixo do chão y=448. O que falhou antes: pano até y=461 e cobrindo as botas.
- Largura: envelope amarelo do template, x 214..298 (largura do quadril + 22 px de cada lado para o balanço do pano).
- Deve deixar os joelhos e o cano das botas legíveis.

### torso, lower_leg_boot_l, lower_leg_boot_r
Mantidos exatamente como estão (byte-idênticos ao pacote P2.4B). Metadata atual continua válida.

## 3. Nomes de arquivo esperados

```text
vss_armor_blackguard_01_upper_arm_l_front3q.png
vss_armor_blackguard_01_upper_arm_r_front3q.png
vss_armor_blackguard_01_forearm_hand_l_front3q.png
vss_armor_blackguard_01_forearm_hand_r_front3q.png
vss_armor_blackguard_01_thigh_l_front3q.png
vss_armor_blackguard_01_thigh_r_front3q.png
vss_armor_blackguard_01_waist_tabard_front3q.png
```

## 4. Fluxo de intake (Claude)

```powershell
cd C:\DEV\Jogo\spirewake
python sandbox\golden_rig_lab\tools\intake_check.py upper_arm_l <arquivo.png> upper_arm_r <arquivo.png> ...
# se OK: copiar para sandbox\golden_rig_lab\assets\armor\armor_blackguard_01\front_3q\ (originais antigos vão para _source_as_delivered\p2_4b_0\)
# atualizar metadata\parts\armor_blackguard_01\<slot>.visual_part.json com o bloco proposto
& $GODOT --headless --path sandbox\golden_rig_lab --import
& $GODOT --path sandbox\golden_rig_lab -- --capture
python sandbox\golden_rig_lab\tools\compare_validation.py docs\05-visual\p2_4b\review_p2_4b_0\blackguard_p2_4b__front3q__right__validation.json sandbox\golden_rig_lab\screenshots\blackguard_p2_4b__front3q__right__validation.json docs\05-visual\p2_4b\P2_4B_1_COMPARISON.md
```

Critérios para o set passar (P2_4B_REAL_REASSEMBLY_SPEC): 10/10 montam; drift distal ≤ 2 px e ângulo ≤ 3° nos 9 slots com bone; zero GR012; zero GR052 nas peças regeneradas; tabard acima do chão; silhueta lê como Blackguard.
