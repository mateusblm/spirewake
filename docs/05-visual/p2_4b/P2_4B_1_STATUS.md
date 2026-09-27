# P2.4B-1 — Status dos slots (armor_blackguard_01 / FRONT_3Q / facing right)

Rig P1.5 intacto em todas as validações. Critério numérico: drift distal ≤ 2.5 px e erro angular ≤ 3° (Lab `LAB01`), PNG RGBA real, alpha sem tocar bordas. Comparação completa: `P2_4B_1_COMPARISON.md`. Capturas: `review_p2_4b_1/`.

| slot | status | arquivo (sha256) | pivot_source | scale | drift distal | erro angular | validado em |
|---|---|---|---|---:|---:|---:|---|
| torso | mantido (P2.4B-0) | pacote P2.4B | (640, 1202) | 0.1250 | 1.1 px → SHOULDER_R | −0.6° | 2026-09-18 |
| lower_leg_boot_l | mantido (P2.4B-0) | pacote P2.4B | (655, 190) | 0.0633 | 2.0 px → FOOT_L | −1.7° | 2026-09-18 |
| lower_leg_boot_r | mantido (P2.4B-0) | pacote P2.4B | (620, 185) | 0.0679 | 1.2 px → FOOT_R | +1.0° | 2026-09-18 |
| upper_arm_l | **validado P2.4B-1** | `98bf390f…` (exec-d3e3e7e9) | (690, 450) | 0.1193 | 2.4 px → ELBOW_L | −2.7° | 2026-09-18 |
| upper_arm_r | **validado P2.4B-1** | `c5f7e604…` (exec-d6f80e63) | (550, 430) | 0.0952 | 0.5 px → ELBOW_R | +0.6° | 2026-09-18 |
| forearm_hand_l | **validado P2.4B-1 — candidata visual final** (v3) | `e3161d56…` (exec-3c07ca82) | (648, 407) | 0.0961 | 1.0 px → HAND_L | +1.2° | 2026-09-18 |
| forearm_hand_r | pendente (regenerar) | — | — | — | 6.7 px | −7.9° | — |
| thigh_l | pendente (regenerar) | — | — | — | 15.5 px | −15.7° | — |
| thigh_r | pendente (regenerar) | — | — | — | 16.1 px | +16.4° | — |
| waist_tabard | pendente (regenerar) | — | — | — | abaixo do chão | — | — |

## Notas de validação

### upper_arm_l (2026-09-18)
- Pivot no centro do domo da ombreira (ombro anatômico). Distal = centro da tampa redonda do cotovelo.
- Na lane `armor_far`, atrás do torso, a ombreira nova fica quase toda escondida pela ombreira própria do torso; só a borda externa e o pano vermelho aparecem. Consequência de D2 + D5, não defeito da peça.
- Transição com `forearm_hand_l` só pode ser julgada quando o antebraço regenerado chegar.

### upper_arm_r (2026-09-18)
- Pivot no centro do domo da ombreira; distal = centro da tampa do cotovelo. Eixo da arte 29.0° vs bone 29.6°.
- Na lane `armor_near`, a ombreira cobre a ombreira do torso e o braço desce no ângulo do bone; leitura compatível com o Blackguard aprovado (metal escuro, filete dourado, cruz, pano vermelho).
- Ombreira R ligeiramente menor que a L em px lógicos (≈32 vs ≈39); irrelevante enquanto a L fica atrás do torso.
- Transição com `forearm_hand_r` pendente do antebraço regenerado.

### forearm_hand_l v3 (2026-09-18) — VALIDADO, candidata visual final

Correção de anatomia da mão esquerda; o antebraço não mudou. Geometria preservada e ligeiramente melhor que a v2.

| medida | v2 | v3 |
|---|---:|---:|
| drift distal em HAND_L | 1.5 px | **1.0 px** |
| erro angular | +1.8° | **+1.2°** |
| pivot_source | (648, 407) | (648, 407) inalterado |
| distal_source | (467, 880) | (472, 882) |
| scale_to_logical | 0.0962 | 0.0961 |

- Arquivo `e3161d56…` (exec-3c07ca82), RGBA 1254×1254, 93.2% transparente, cantos limpos, alpha sem tocar bordas.
- Eixo do tubo do antebraço idêntico à v2 (−12.8° em y 430..660, −15.7° em y 450..700): a correção mexeu só na mão.
- HAND_L esperado (174, 322); mão pintada cai em (173.09, 321.65). O aviso `LAB01` desapareceu.
- **offhand_socket dentro da mão: confirmado por pixel.** O socket cai em (482, 886) na arte, alpha 253, com os 25 pontos de uma caixa de 80 px todos opacos. Margens até a silhueta: 10.9 px lógicos à esquerda, 7.5 à direita, 24.2 acima, 8.9 abaixo. O escudo terá apoio sólido.
- **Transição com upper_arm_l:** limpa, inalterada em relação à v2.

### forearm_hand_l v2 (2026-09-18) — VALIDADO (substituída pela v3)

- Arquivo `a4f89313…` (exec-c109eb45), RGBA 1254×1254, 93.3% transparente, cantos limpos, alpha sem tocar bordas. GR012 resolvido.
- Pivot = centro da elipse da boca do punho (648, 407). Distal = centroide de alpha da mão abaixo da linha do pulso y=800 → (467, 880).
- Eixo do tubo do antebraço −19.5° contra bone −19.2°. **Drift 1.5 px, erro angular +1.8°.** HAND_L esperado (174, 322), mão pintada cai em (172.6, 321.5).
- Robustez: nove combinações plausíveis de pivot/distal dão erro entre −1.8° e −2.8°, todas dentro do critério.
- **Transição com upper_arm_l:** limpa. A boca do punho encosta sob a tampa do cotovelo do braço superior e o pano vermelho cobre a emenda. Braço lê como membro contínuo do ombro à mão.
- `offhand_socket` (HAND_L) cai dentro do punho fechado, então o escudo terá ponto de apoio correto.

### forearm_hand_l v1 (2026-09-18) — REPROVADO por ângulo (substituído)

- **Alpha: aprovado.** PNG RGBA real, 90.8% transparente, cantos limpos, alpha sem tocar bordas. Pixels dispersos de alpha 1 são invisíveis. GR012 **resolvido** (o JPEG anterior saiu).
- **Geometria: reprovado.** Eixo do tubo do antebraço, ajustado por regressão sobre as linhas y=560..710, dá **−28.5°** da vertical. Isso é o ângulo do bone `upper_arm_l` (−29.6°), não o do bone `forearm_hand_l` (**−19.2°**).
- Com pivot no centro da boca do punho (725,530) e distal no centro da mão (495,920): **drift 9.6 px, erro angular +11.4°**. A mão pintada cai em (165.3, 318.0); HAND_L está em (174, 322).
- O erro não depende da escolha de pontos: testadas três leituras plausíveis (boca→centro da mão, boca→centro da placa da palma, boca→ponta dos dedos), o erro fica entre −9.4° e −13.3°.
- **Causa:** a peça foi desenhada como continuação reta do braço superior, sem a dobra do cotovelo que o rest pose P1 v2 tem. O rig tem `upper_arm` a −29.6° e `forearm` a −19.2°; a arte usa −28.5° nos dois.
- **Consequência funcional:** `offhand_socket` fica em HAND_L, mas a mão pintada está 9.6 px fora, 20% do comprimento do antebraço. O escudo ficaria solto da mão.
- **Correção:** regenerado a −19.5° na v2 acima. Arquivo original preservado em `assets/.../front_3q/_source_as_delivered/p2_4b_1_rejected/`.
- Arte e material estavam conformes ao Blackguard aprovado; só o ângulo reprovou.

## Restante do pass
Regenerar `forearm_hand_l`, `forearm_hand_r`, `thigh_l`, `thigh_r`, `waist_tabard` conforme `P2_4B_1_REGENERATION_BRIEF.md`. Só depois disso o set pode ser avaliado para congelamento `armor_blackguard_01 / FRONT_3Q / v1`.
