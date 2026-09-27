# Progressão dos Ascendentes

**Status:** FROZEN, exceto opções finais específicas de L20.

## 1. Nível máximo

Nível máximo da V1: **20**.

## 2. Ritmo desejado

Para um Ascendente usado com frequência:

- L5: ~7 encontros;
- L10: ~20 encontros;
- L15: ~38 encontros;
- L20: ~65 encontros.

A progressão é orientada por encontros sobrevividos, não por andar fixo.

## 3. XP

XP é concedido aos Ascendentes que participaram e sobreviveram ao encontro.

- Normal: 100 XP;
- Elite: 125 XP;
- Boss: 150 XP.

Não existe XP por kill individual. Personagem morto no encontro não recebe XP daquele encontro. Quem ficou na Base não recebe XP passivo.

Tabela acumulada:

| Transição | XP necessário | XP acumulado |
|---|---:|---:|
| L1 → L2 | 140 | 140 |
| L2 → L3 | 160 | 300 |
| L3 → L4 | 190 | 490 |
| L4 → L5 | 210 | 700 |
| L5 → L6 | 220 | 920 |
| L6 → L7 | 240 | 1.160 |
| L7 → L8 | 260 | 1.420 |
| L8 → L9 | 280 | 1.700 |
| L9 → L10 | 300 | 2.000 |
| L10 → L11 | 320 | 2.320 |
| L11 → L12 | 340 | 2.660 |
| L12 → L13 | 360 | 3.020 |
| L13 → L14 | 380 | 3.400 |
| L14 → L15 | 400 | 3.800 |
| L15 → L16 | 460 | 4.260 |
| L16 → L17 | 500 | 4.760 |
| L17 → L18 | 540 | 5.300 |
| L18 → L19 | 580 | 5.880 |
| L19 → L20 | 620 | 6.500 |

## 4. Crescimento automático por nível

A cada nível, o Ascendente recebe um pequeno orçamento automático de atributos.

Baseline para Potencial B: **4 pontos por nível**.

Multiplicadores de Potencial:

- D ×0,75 → ~3,0 pontos/nível;
- C ×0,90 → ~3,6;
- B ×1,00 → 4,0;
- A ×1,15 → ~4,6;
- S ×1,35 → ~5,4.

Frações são acumuladas internamente e convertidas em pontos inteiros de forma determinística ao longo dos níveis.

A distribuição usa:

1. pesos da classe;
2. pequeno perfil individual derivado da seed.

O jogador não distribui pontos manualmente.

Regra conceitual:

- Rank = força inicial;
- Potencial = quantidade/velocidade de crescimento;
- classe + perfil individual = direção do crescimento.

## 5. Marcos de progressão

### Classes base

- L5 — escolher 1 entre 2 evoluções menores;
- L10 — escolher 1 entre 2 evoluções menores;
- L15 — escolher permanentemente 1 das 2 especializações;
- L20 — escolher 1 entre 2 evoluções finais específicas da especialização.

### Novato

- L5 — evolução genérica;
- L10 — Despertar com 2–3 opções de classe base;
- L15 — evolução menor da nova classe;
- L20 — escolher 1 das 2 especializações da classe despertada.

L20 não cria terceira ramificação nem nova classe.

## 6. Evolução pendente

Se um marco for atingido durante uma expedição:

- o nível e ganhos numéricos normais entram imediatamente;
- a escolha permanente fica pendente;
- a decisão só é feita na Base;
- enquanto houver evolução de marco pendente, aquele Ascendente não pode voltar à Torre;
- isso não bloqueia o restante do jogo;
- após a escolha, autosave imediato.

## 7. Regras de oferta de evolução menor

Para classes base em L5 e L10:

- sempre 2 opções;
- pelo menos 1 específica da classe;
- a segunda pode ser específica ou genérica;
- evolução já escolhida não reaparece;
- incompatibilidades removem opções do pool;
- personalidade e Traits podem dar peso leve à oferta, sem determiná-la;
- oferta é determinística pela seed e não pode ser rerrolada por reload.

Para Novato L5:

- as 2 opções vêm somente do pool genérico.

No L10 do Novato:

- não existe evolução menor; ocorre o Despertar.

## 8. Evoluções genéricas — catálogo V1

### 1. Condicionamento
Aumento moderado permanente de **Vitalidade + Determinação**.

### 2. Reflexos Treinados
Aumento moderado permanente de **Agilidade + Foco**.

### 3. Potência Desenvolvida
Aumento maior permanente de **Poder**.

### 4. Sangue Frio
Reduz moderadamente o Stress recebido durante a expedição.

### 5. Técnica Refinada
Melhora levemente frequência/eficiência da habilidade automática principal, sem criar ação nova.

### 6. Recuperação Rápida
Ao sobreviver a um encontro, recupera pequena parcela de HP antes do próximo.

Valores finos são tunáveis em playtest.

## 9. Evoluções específicas — Vanguarda

1. **Postura Firme** — aumenta Vitalidade e reduz levemente impacto de reposicionamentos na frente/meio.
2. **Reflexo de Guarda** — Interceptar reage mais rápido e alcança aliados um pouco mais distantes.
3. **Guarda Fechada** — após Interceptar, recebe breve redução de dano.
4. **Presença de Combate** — inimigos já engajados dão mais peso para manter a Vanguarda como alvo.
5. **Contra-pressão** — após Interceptar, próximo Golpe de Arma recebe aumento moderado de impacto/dano.
6. **Instinto de Proteção** — Utility AI aumenta prioridade de reagir a aliados com HP baixo ou sob múltiplas ameaças.

## 10. Evoluções específicas — Atirador

1. **Mãos Firmes** — aumenta Foco e consistência de ataques à distância.
2. **Alvo Exposto** — Mira Prioritária pesa mais inimigos isolados/mal protegidos.
3. **Passo Rápido** — sob pressão melee, reposiciona mais cedo.
4. **Tiro de Oportunidade** — inimigo que muda de posição ou fica exposto recebe prioridade temporária maior.
5. **Mira Persistente** — reduz trocas desnecessárias de alvo e favorece finalização.
6. **Distância Segura** — aumenta prioridade por anchors com boa distância de ameaças melee.

## 11. Evoluções específicas — Arcanista

1. **Concentração Arcana** — aumenta Foco e consistência de habilidades mágicas.
2. **Núcleo Instável** — Ruptura Arcana ganha mais impacto ao atingir 2+ inimigos.
3. **Geometria de Combate** — Utility AI valoriza melhor agrupamentos e posições multi-alvo.
4. **Resíduo Arcano** — alvos de Ruptura ficam brevemente mais vulneráveis à próxima fonte de dano mágico.
5. **Canalização Segura** — reduz tendência de abandonar habilidade importante sob pressão leve.
6. **Foco Obsessivo** — aumenta tendência de manter pressão em alvo relevante já enfraquecido.

## 12. Evoluções específicas — Suporte

1. **Cuidado Preciso** — aumenta Foco e eficiência do Amparo.
2. **Resposta Rápida** — Amparo reage mais cedo quando aliado entra em risco.
3. **Presença Tranquilizadora** — aliados próximos acumulam um pouco menos de Stress enquanto o Suporte está bem posicionado.
4. **Prioridade Crítica** — Utility AI pesa mais aliados com HP muito baixo ou sob foco múltiplo.
5. **Apoio Oportuno** — após Amparo, o alvo recebe curta melhora de eficiência.
6. **Cobertura de Retaguarda** — Suporte valoriza anchors que mantenham vários aliados em alcance e reposiciona antes de perder cobertura.

## 13. L20

A regra estrutural está congelada, mas o conteúdo final não:

- cada especialização terá 2 evoluções finais próprias;
- o jogador escolhe 1 permanentemente;
- não criar essas 16 opções antes da fase de expansão além do Vertical Slice, salvo se uma tarefa explícita exigir suporte para testes de L20.
