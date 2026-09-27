# Balance Model v0.1

**Status:** BALANCE_V0_1

Este documento é o dono canônico dos valores numéricos de gameplay. A arquitetura das fórmulas está congelada; valores explicitamente marcados como **TUNABLE** podem mudar após playtest sem reabrir o design conceitual.

---

## 1. Rank — orçamento inicial de atributos

Faixas congeladas:

- D = 240–260;
- C = 270–290;
- B = 300–320;
- A = 330–350;
- S = 360–380.

Pontos médios usados no modelo:

- D = 250;
- C = 280;
- B = 310;
- A = 340;
- S = 370.

Rank define orçamento total inicial, não distribuição homogênea.

---

## 2. Pesos-base de atributos por classe

Esses pesos são baseline congelada para geração; a seed pode aplicar pequeno desvio individual e renormalizar para 100%.

| Classe | Poder | Vitalidade | Agilidade | Foco | Determinação |
|---|---:|---:|---:|---:|---:|
| Vanguarda | 22% | 25% | 16% | 15% | 22% |
| Atirador | 22% | 16% | 24% | 23% | 15% |
| Arcanista | 22% | 16% | 15% | 26% | 21% |
| Suporte | 14% | 18% | 16% | 26% | 26% |
| Novato | 20% | 20% | 20% | 20% | 20% |

Desvio individual recomendado: aproximadamente ±3 pontos percentuais antes de renormalizar. O algoritmo exato pode ser definido na arquitetura desde que preserve a intenção e o total.

---

## 3. Potencial e crescimento por nível

Multiplicadores congelados:

- D = ×0,75;
- C = ×0,90;
- B = ×1,00;
- A = ×1,15;
- S = ×1,35.

Baseline de crescimento em Potencial B: **4 pontos de atributo por nível**.

Média por nível:

- D ≈ 3,0;
- C ≈ 3,6;
- B = 4,0;
- A ≈ 4,6;
- S ≈ 5,4.

Frações acumulam internamente e são materializadas em pontos inteiros de forma determinística.

---

## 4. HP

Fórmula congelada:

`HP Máximo = 400 + (Vitalidade × 8)`

Exemplos:

- Vit 25 → 600 HP;
- Vit 50 → 800 HP;
- Vit 75 → 1.000 HP;
- Vit 100 → 1.200 HP.

Vitalidade não aumenta Armadura automaticamente.

---

## 5. Defesas-base por classe

Baseline congelada:

| Classe | Armadura | Resistência Arcana |
|---|---:|---:|
| Vanguarda | 35 | 20 |
| Atirador | 15 | 15 |
| Arcanista | 10 | 30 |
| Suporte | 15 | 25 |
| Novato | 20 | 20 |

Fórmula de mitigação congelada:

`Dano final = Dano bruto × 100 / (100 + Resistência relevante)`

- dano Físico usa Armadura;
- dano Arcano usa Resistência Arcana.

---

## 6. Agilidade

Fórmula congelada:

`Multiplicador de ação = 1 + (Agilidade × 0,0035)`

Exemplos:

- Agi 0 → 100%;
- Agi 25 → 108,75%;
- Agi 50 → 117,5%;
- Agi 75 → 126,25%;
- Agi 100 → 135%.

Intervalo real:

`intervalo = intervalo-base / multiplicador de ação`

Intervalos-base congelados:

| Classe | Intervalo-base |
|---|---:|
| Vanguarda | 2,20 s |
| Atirador | 2,00 s |
| Arcanista | 2,30 s |
| Suporte | 2,40 s |
| Novato | 2,10 s |

Agilidade **não reduz cooldowns**.

---

## 7. Arquitetura de scaling de habilidades

Fórmula estrutural congelada:

`Efeito bruto = Valor Base + Poder×coefP + Foco×coefF`

Cada habilidade possui coeficientes próprios.

### Coeficientes candidatos — TUNABLE

| Ação | Fórmula v0.1 |
|---|---|
| Golpe de Arma | `22 + 0,72×Poder` |
| Disparo Preciso | `18 + 0,62×Poder + 0,18×Foco` |
| Mira Prioritária | `35 + 0,85×Poder + 0,35×Foco` |
| Projétil Arcano | `18 + 0,35×Poder + 0,45×Foco` |
| Ruptura Arcana | `28 + 0,40×Poder + 0,65×Foco` por alvo |
| Pulso de Apoio | `12 + 0,20×Poder + 0,22×Foco` |
| Amparo | `55 + 0,15×Poder + 0,95×Foco` de cura |
| Golpe Instintivo | `18 + 0,55×Poder` |

### Cooldowns candidatos — TUNABLE

- Mira Prioritária: 7 s;
- Ruptura Arcana: 8 s;
- Amparo: 8 s;
- Interceptar: 8 s;
- Adrenalina: janela/cooldown interno aproximado de 12 s.

Esses valores só devem ser congelados depois do primeiro combate jogável.

---

## 8. Regra de RNG de combate

Congelado para V1:

- sem chance de crítico;
- sem miss;
- sem dodge aleatório;
- sem block aleatório;
- sem variação aleatória de dano.

RNG comportamental permitido deve ser determinístico pela seed quando afetar estado persistente/reprodução do combate.

---

## 9. XP

Congelado:

- Normal = 100 XP;
- Elite = 125 XP;
- Boss = 150 XP.

Tabela de nível:

| Transição | XP | Total |
|---|---:|---:|
| 1→2 | 140 | 140 |
| 2→3 | 160 | 300 |
| 3→4 | 190 | 490 |
| 4→5 | 210 | 700 |
| 5→6 | 220 | 920 |
| 6→7 | 240 | 1.160 |
| 7→8 | 260 | 1.420 |
| 8→9 | 280 | 1.700 |
| 9→10 | 300 | 2.000 |
| 10→11 | 320 | 2.320 |
| 11→12 | 340 | 2.660 |
| 12→13 | 360 | 3.020 |
| 13→14 | 380 | 3.400 |
| 14→15 | 400 | 3.800 |
| 15→16 | 460 | 4.260 |
| 16→17 | 500 | 4.760 |
| 17→18 | 540 | 5.300 |
| 18→19 | 580 | 5.880 |
| 19→20 | 620 | 6.500 |

Alvos de ritmo:

- L5 ≈ 7 encontros;
- L10 ≈ 20;
- L15 ≈ 38;
- L20 ≈ 65.

---

## 10. Cansaço

Escala congelada: 0–100.

Estados:

- 0–24 Descansado;
- 25–49 Cansado;
- 50–74 Muito Cansado;
- 75–100 Exausto.

Ganho congelado por encontro concluído:

- Normal +4;
- Elite +6;
- Boss +10.

Recuperação congelada na Base:

- −5 por encontro concluído pela equipe ativa;
- máximo −20 por expedição.

Efeitos atuais — **TUNABLE**:

- Cansado: +10% Stress recebido;
- Muito Cansado: +20% Stress recebido e −5% velocidade de ação;
- Exausto: não entra na Torre.

---

## 11. Stress — fórmula

Fórmula congelada:

`StressFinal = StressBase × (1 − Determinação×0,0035) × ModCansaço × OutrosMods`

Clamp final: 0–100.

Multiplicadores de Cansaço:

- Descansado ×1,00;
- Cansado ×1,10;
- Muito Cansado ×1,20;
- Exausto não entra na Torre.

Determinação em 100 reduz 35% do Stress recebido antes de outros modificadores.

Reduções adicionais de Stress são multiplicativas. Teto geral recomendado/congelado como baseline: aproximadamente 50% de redução total.

---

## 12. Stress — eventos-base

Congelado:

| Evento | Stress base | Observação |
|---|---:|---|
| receber em uma ação dano ≥20% do HP máximo | +8 | após mitigação; cooldown interno curto |
| cruzar abaixo de 50% HP | +6 | 1x por encontro |
| cruzar abaixo de 25% HP | +10 | 1x por encontro |
| sofrer controle/desorganização relevante | +5 | cooldown interno |
| morte de aliado | +20 | todos os sobreviventes |
| entrar em Boss | +6 | 1x no início |
| habilidade principal do Boss | +12 | substitui +8 de dano pesado na mesma ação |

Cooldowns internos recomendados — **TUNABLE**:

- dano pesado: ~4 s;
- controle: ~6 s.

Eventos distintos podem acumular; o mesmo motivo não duplica.

---

## 13. Stress — recuperação

Não há regeneração passiva entre encontros.

Recuperação atual — **TUNABLE**:

- vitória Normal: −3;
- vitória Elite: −5;
- vitória Boss: −8.

Ao voltar à Base, Stress zera para 0 independentemente de conclusão, recuo ou derrota.

Inspirador — Impulso Inspirador: aproximadamente **−8 Stress** no alvo, **TUNABLE**.

Suporte base e Médico não removem Stress diretamente.

---

## 14. Stress — estados e amplificação comportamental

Faixas congeladas:

- 0–24 Estável;
- 25–49 Pressionado;
- 50–74 Abalado;
- 75–100 Crítico.

Multiplicadores atuais de personalidade/Traits — **TUNABLE**:

- Estável ×1,00;
- Pressionado ×1,15;
- Abalado ×1,35;
- Crítico ×1,65.

Disciplina reduz apenas o bônus adicional causado pelo estado:

`AmplificaçãoEfetiva = 1 + BonusDoEstado × (1 − Disciplina×0,005)`

Coragem, Prudência e Empatia não alteram numericamente o Stress recebido na V1.

---

## 15. Determinação e controle

Redução de Stress por Determinação: 0,35% por ponto, conforme fórmula acima.

Redução de duração de controle: **0,12% por ponto**, máximo ~12% em Determinação 100.

---

## 16. Economia de summon

Congelado:

- 1 summon = 100 recurso;
- conclusão de andar = +40;
- Elite = +10 imediato;
- Boss andar 10 = +30 adicional;
- revisitas recompensam normalmente na V1.

### Origem normal

- Novato 25%;
- Vanguarda 18,75%;
- Atirador 18,75%;
- Arcanista 18,75%;
- Suporte 18,75%.

### Rank normal

- D 38%;
- C 32%;
- B 20%;
- A 8%;
- S 2%.

### Potencial normal

- D 20%;
- C 28%;
- B 30%;
- A 17%;
- S 5%.

---

## 17. Convergência — Rank

Índice: D=0, C=1, B=2, A=3, S=4. Score = soma dos dois.

| Score | D | C | B | A | S |
|---:|---:|---:|---:|---:|---:|
| 0 | 28% | 31% | 24% | 13% | 4% |
| 1 | 24% | 29% | 26% | 15% | 6% |
| 2 | 19% | 27% | 28% | 18% | 8% |
| 3 | 14% | 24% | 29% | 22% | 11% |
| 4 | 10% | 19% | 28% | 27% | 16% |
| 5 | 6% | 15% | 26% | 31% | 22% |
| 6 | 3% | 10% | 23% | 33% | 31% |
| 7 | 1% | 6% | 18% | 34% | 41% |
| 8 | 1% | 3% | 13% | 32% | 51% |

Status: **BALANCE_V0_1 / TUNABLE** sem mudar arquitetura.

---

## 18. Convergência — Potencial

| Score | D | C | B | A | S |
|---:|---:|---:|---:|---:|---:|
| 0 | 13% | 23% | 32% | 23% | 9% |
| 1 | 10% | 21% | 32% | 26% | 11% |
| 2 | 8% | 18% | 31% | 29% | 14% |
| 3 | 5% | 14% | 30% | 32% | 19% |
| 4 | 3% | 11% | 27% | 35% | 24% |
| 5 | 2% | 7% | 23% | 37% | 31% |
| 6 | 1% | 4% | 18% | 37% | 40% |
| 7 | 0% | 3% | 13% | 35% | 49% |
| 8 | 0% | 1% | 9% | 31% | 59% |

Status: **BALANCE_V0_1 / TUNABLE** sem mudar arquitetura.

Viés de mesma origem/linhagem: peso ×1,35 e renormalização.

---

## 19. Escala de inimigos por andar

Baseline estrutural:

`Escala = 1 + 0,02 × (andar − 1)`

Exemplos:

- andar 1 = 100%;
- andar 5 = 108%;
- andar 9 = 116%;
- andar 10 = 118%.

A dificuldade também cresce por composição, quantidade, sinergia, Elites e persistência de estados.

---

## 20. HP de inimigos — modelo inicial TUNABLE

Valores usados apenas para sanity check inicial:

| Inimigo | HP-base v0.1 |
|---|---:|
| Agressor simples | 1.100 |
| Defensor | 1.450 |
| Agressor explosivo | 900 |
| Atirador | 800 |
| Conjurador | 800 |
| Suporte | 850 |

Não estão congelados.

Boss testado aproximadamente com 8.000 HP + 2 escoltas. Não congelado.

---

## 21. Metas de duração — TUNABLE

Alvos iniciais:

- Normal: ~20–35 s;
- Elite: acima do Normal conforme modificador/composição;
- Boss: ~60–90 s.

Sanity check do modelo inicial:

- T1 ~18 s;
- T2 ~21 s;
- T3 ~21 s;
- T4 ~27 s;
- T5 ~30–31 s;
- Guardião do Limiar ~60 s antes de polish/telegraph/proteção final.

Esses tempos são objetivos de playtest, não contrato rígido.
