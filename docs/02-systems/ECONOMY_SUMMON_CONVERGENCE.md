# Economia, Invocação e Convergência

**Status:** FROZEN. Percentuais de Convergência são `Convergence Balance v0.1` e podem ser refinados por playtest sem mudar a arquitetura.

## 1. Princípios

O Vertical Slice possui apenas **1 recurso de invocação**.

Não existem na V1:

- moeda premium;
- tickets;
- fragmentos;
- múltiplas moedas de summon;
- 10-pulls.

**1 invocação = 1 Ascendente.**

O nome “Essência” é provisório e não é decisão de lore final.

## 2. Custo e obtenção

- custo de 1 summon: **100** do recurso;
- conclusão de andar: **+40**;
- vitória em Elite: **+10**, entregue imediatamente e preservado mesmo se houver recuo depois;
- vitória no Boss do andar 10: **+30** adicional;
- recuar antes de concluir o andar não concede os +40;
- revisitas concedem recompensas normalmente no Vertical Slice;
- não há anti-farm/redução de recompensa na V1.

Cadência alvo: aproximadamente **1 summon a cada 2–3 andares concluídos**.

## 3. Roster

- capacidade máxima inicial: **15 Ascendentes**;
- se o roster estiver 15/15, summon normal fica bloqueado;
- não existe overflow/mailbox na V1;
- Convergência pode ser usada em 15/15 porque reduz o roster em 1 líquido.

## 4. Distribuição de origem — summon normal

- Novato: **25%**;
- Vanguarda: **18,75%**;
- Atirador: **18,75%**;
- Arcanista: **18,75%**;
- Suporte: **18,75%**.

Origem é independente de Rank.

## 5. Distribuição de Rank — summon normal

- D: **38%**;
- C: **32%**;
- B: **20%**;
- A: **8%**;
- S: **2%**.

## 6. Distribuição de Potencial — summon normal

- D: **20%**;
- C: **28%**;
- B: **30%**;
- A: **17%**;
- S: **5%**.

Potencial é independente de Rank.

## 7. First Call

O início de um novo save/conta usa um perfil especial de onboarding, separado das taxas normais.

Gera exatamente 5 Ascendentes:

- 1 Vanguarda;
- 1 Atirador;
- 1 Arcanista;
- 1 Suporte;
- 1 Novato.

Todos continuam procedurais em nome, aparência, personalidade, Traits e perfil de crescimento.

Salvaguardas do lote:

- no máximo 2 Rank D;
- pelo menos 1 Rank B ou superior;
- pelo menos 1 Potencial A ou S.

Regras:

- gratuito;
- acontece uma vez por save/conta;
- determinístico pela seed;
- sem reroll dentro do jogo;
- origem persistida como `FIRST_CALL`.

## 8. Apresentação da invocação

A invocação deve ser um momento especial, curto e repetível. Fluxo funcional:

1. ritual começa;
2. silhueta;
3. aparência completa;
4. nome;
5. classe ou Novato;
6. Rank;
7. Potencial;
8. Traits;
9. tela final resumida.

A separação entre Rank e Potencial é deliberada para criar revelações como “Rank baixo, Potencial alto”.

A tela final mostra o essencial e oferece acesso a detalhes completos.

Ranks altos podem receber feedback audiovisual mais forte, sem exigir pipelines diferentes.

A animação deve poder ser pulada depois que o jogador já estiver familiarizado; comportamento exato de skip entra no UX final.

## 9. Nomes

Nomes usam catálogo curado de nomes inteiros na V1. Geração por sílabas não é baseline.

## 10. Convergência

### Regra central

**2 Ascendentes → ambos consumidos permanentemente → 1 novo Ascendente → libera 1 vaga líquida.**

- pode ser usada com roster cheio;
- não possui custo adicional de recurso;
- novo Ascendente é uma pessoa nova;
- não herda aparência, personalidade, Traits, evoluções, nível ou XP;
- começa no L1;
- Rank e Potencial dos dois consumidos influenciam separadamente o novo resultado;
- linhagem/origem influencia apenas levemente a origem do novo.

Nível, XP, atributos, personalidade, Traits, evoluções e aparência dos pais **não alteram as odds**.

## 11. Índices da Convergência

Internamente:

- D = 0;
- C = 1;
- B = 2;
- A = 3;
- S = 4.

Calcula-se separadamente:

`scoreRank = rank1 + rank2`

`scorePotencial = potencial1 + potencial2`

Cada score varia de 0 a 8.

## 12. Tabela de Rank — Convergence Balance v0.1

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

Mesmo dois D não garantem C; mesmo dois A/S não garantem preservar ou subir a letra.

## 13. Tabela de Potencial — Convergence Balance v0.1

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

## 14. Viés de origem/linhagem

A distribuição-base de origem continua a mesma do summon normal.

Se os dois consumidos forem da **mesma linhagem base/origem**, o peso dessa origem é multiplicado por **1,35×** e a distribuição é renormalizada.

Especializações contam pela linhagem base:

- Guardião + Devastador → viés de Vanguarda;
- Guardião + Guardião → mesmo viés de Vanguarda, sem bônus extra por mesma especialização.

Se as linhagens forem diferentes, não existe combinação/breeding especial.

## 15. Transparência e persistência da Convergência

Antes da confirmação, a UI deve mostrar:

- os 2 Ascendentes que serão perdidos;
- odds de Rank;
- odds de Potencial;
- tendência de origem quando houver;
- aviso explícito de perda permanente.

Após confirmar:

1. resultado é determinado pela seed;
2. autosave ocorre antes da revelação;
3. reload não rerrola o resultado;
4. o novo Ascendente passa pelo pipeline normal de geração a partir dos resultados de Rank/Potencial/origem.

A Convergência é uma ferramenta de roster e risco, não uma escada garantida de upgrade e não deve transformar ranks baixos em “fodder automático”.
