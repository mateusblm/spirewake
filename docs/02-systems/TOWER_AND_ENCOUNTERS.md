# Torre e Encontros

**Status:** FROZEN

## 1. Estrutura geral

A Torre é uma progressão linear de andares. O jogo mantém um **andar máximo alcançado**.

- o próximo andar de progressão é sempre o seguinte ao máximo alcançado;
- não é possível pular andares;
- qualquer andar já concluído pode ser revisitado;
- recuar ou falhar não reduz o andar máximo alcançado;
- ao concluir qualquer andar, o retorno à Base é obrigatório.

O Vertical Slice contém **10 andares**.

## 2. Estrutura de um andar

Um andar é uma mini-expedição linear com 3–5 encontros.

- HP e Stress persistem entre encontros;
- mortos permanecem mortos;
- não há troca por reservas durante o andar;
- o jogador pode recuar somente entre encontros;
- depois que um Boss começa, não há recuo.

## 3. Tipos de encontro

### Normal
Encontro padrão. Gera XP e desgaste, sem modificador exclusivo.

### Elite
Composição comum + 1 modificador Elite simples. A variedade vem da combinação, não de um inimigo artesanal novo.

### Boss
Encontro de marco com identidade e mecânica própria fixa. Não usa modificador Elite aleatório.

## 4. Seis inimigos comuns

### 1. Agressor simples

- melee;
- pressão direta;
- prioriza proximidade/alvo acessível;
- ataque básico consistente;
- sem mecânica especial ou burst exagerado.

Função: ensinar leitura básica de formação, proteção e foco.

### 2. Defensor

- linha de frente;
- mais resistente que Agressor simples;
- intercepta ameaças contra aliados frágeis, especialmente de retaguarda.

Função: primeira sinergia de proteção e mudança de prioridade de alvo.

### 3. Agressor explosivo

- melee;
- mais frágil;
- ataque básico normal;
- periodicamente prepara golpe forte com telegraph claro;
- se não for eliminado/interrompido/mitigado, gera pico relevante de dano.

Função: criar urgência e prioridade de alvo.

### 4. Atirador de retaguarda

- baixa resistência;
- pouca mobilidade;
- dano consistente à distância;
- prefere alvos vulneráveis/expostos.

Função: criar ameaça fora da linha de frente.

### 5. Conjurador de área/controle

- frágil, de retaguarda;
- ataque básico fraco;
- habilidade periódica telegrafada contra pequena área/conjunto próximo de anchors;
- dano moderado + controle leve;
- sem controles longos/frustrantes.

Função: punir agrupamento excessivo.

### 6. Suporte inimigo

- frágil, de retaguarda;
- dano quase irrelevante;
- aplica buff temporário ofensivo ou defensivo visualmente claro em aliado próximo.

Função: criar decisão de prioridade entre ameaça principal e suporte.

## 5. Templates de composição

### T1 — Linha Simples
**2 Agressor simples + 1 Atirador**

Introdução à leitura frente + ameaça de retaguarda.

### T2 — Muralha e Pressão
**1 Defensor + 1 Agressor simples + 1 Atirador**

Introduz proteção e prioridade de alvo.

### T3 — Ruptura
**1 Defensor + 1 Agressor explosivo + 1 Conjurador**

Combina urgência em alvo único com pressão sobre agrupamento/formação.

### T4 — Pressão Sustentada
**1 Agressor simples + 1 Atirador + 1 Suporte + 1 Defensor**

Primeiro grupo de 4; cria prioridade ambígua entre Suporte, Atirador e linha de frente.

### T5 — Cerco Coordenado
**1 Defensor + 1 Agressor explosivo + 1 Atirador + 1 Conjurador + 1 Suporte**

Composição comum mais exigente. Testa leitura, formação, foco e comando sem apresentar regra nova.

## 6. Modificadores Elite

### Couraça
Todos os inimigos recebem maior resistência física. Não deve transformar a luta em esponja de HP.

### Véu Arcano
Todos os inimigos recebem maior resistência mágica.

### Frenesi
Todos recebem maior velocidade de ação e comportamento mais agressivo, sem aumento simultâneo de dano bruto como baseline.

Valores exatos são tunáveis em playtest.

## 7. Boss do andar 10 — Guardião do Limiar

Nome de trabalho canônico do Vertical Slice.

### Composição

- Boss de linha de frente;
- 2 escoltas conhecidas: baseline 1 Defensor + 1 Agressor simples.

### Mecânica central — Proteção da Escolta

Enquanto as escoltas estão vivas, o Boss recebe proteção relevante contra dano.

- não fica invulnerável;
- cada escolta eliminada reduz a proteção;
- jogador decide entre insistir no Boss ou desmontar a defesa.

### Habilidade — Golpe do Limiar

- ataque pesado;
- telegraph visual claro;
- direcionado a região da formação ou alvo prioritário;
- dano alto;
- gera pressão adicional de Stress.

### Limites

Não possui no Vertical Slice:

- segunda fase;
- invocação infinita;
- enrage complexo;
- ressurreição de escoltas;
- múltiplas mecânicas simultâneas.

O Boss deve testar conceitos já ensinados.

## 8. Primeiro clear — sequência curada

| Andar | Encontros | Sequência | Elite/Boss | Objetivo |
|---|---:|---|---|---|
| 1 | 3 | T1 → T1 → T1 | — | leitura básica |
| 2 | 3 | T1 → T2 → T1 | — | introduzir Defensor |
| 3 | 3 | T2 → T1 → T2 Elite | Frenesi | primeiro Elite |
| 4 | 4 | T2 → T3 → T1 → T3 | — | explosivo + Conjurador |
| 5 | 4 | T3 → T2 → T4 → T3 Elite | Couraça | Suporte + adaptação |
| 6 | 4 | T4 → T3 → T2 → T4 | — | consolidar prioridades |
| 7 | 4 | T3 → T4 → T2 → T4 Elite | Véu Arcano | testar variedade |
| 8 | 4 | T4 → T3 → T5 → T4 | — | introduzir T5 |
| 9 | 5 | T5 → T4 → T3 → T5 Elite → T4 | 1 dos 3 | prova pré-Boss |
| 10 | 3 | T4 → T5 → Guardião do Limiar | Boss | culminação |

Total do first clear: **37 encontros**.

## 9. Revisitas

Primeiro clear é curado. Revisitas usam geração determinística dentro de orçamento fixo.

Quantidade de encontros permanece igual ao first clear.

| Andar | Encontros | Pool | Elite/Boss |
|---|---:|---|---|
| 1 | 3 | T1 | nenhum |
| 2 | 3 | T1, T2 | nenhum |
| 3 | 3 | T1, T2 | exatamente 1 Elite |
| 4 | 4 | T1, T2, T3 | nenhum |
| 5 | 4 | T2, T3, T4 | exatamente 1 Elite |
| 6 | 4 | T2, T3, T4 | nenhum |
| 7 | 4 | T2, T3, T4 | exatamente 1 Elite |
| 8 | 4 | T3, T4, T5 | nenhum |
| 9 | 5 | T3, T4, T5 | exatamente 1 Elite |
| 10 | 3 | T4/T5 → T4/T5 → Boss | Boss fixo |

Regras adicionais:

- templates mais difíceis recebem peso maior nos andares altos;
- se houver mais de um template disponível, o mesmo template não aparece duas vezes seguidas;
- Elite nunca é o primeiro encontro;
- andar 3: apenas Frenesi;
- andar 5: Frenesi ou Couraça;
- andar 7+: Frenesi, Couraça ou Véu Arcano;
- andar 10 não recebe Elite antes do Boss;
- Boss do 10 é sempre o último encontro.

Ao confirmar a revisita, a seed define e salva:

- sequência de templates;
- posição do Elite;
- modificador Elite;
- formação/anchors inimigos.

Reabrir o jogo não rerrola. Uma nova revisita recebe nova seed.

## 10. Escala de dificuldade

Baseline estrutural:

`Escala do andar = 1 + 0,02 × (andar - 1)`

A dificuldade não deve depender apenas de números. Cresce também por:

- composições mais fortes;
- mais inimigos simultâneos;
- sinergias melhores;
- Elites;
- HP/Stress persistentes;
- Cansaço entre expedições;
- Boss.

No jogo completo, a visão de longo prazo é escalar a Torre por blocos de aproximadamente 10 andares, com crescimento suave dentro do bloco e pequeno salto de complexidade entre blocos.
