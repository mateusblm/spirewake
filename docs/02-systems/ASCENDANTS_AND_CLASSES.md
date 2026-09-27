# Ascendentes e Classes

**Status:** FROZEN

## 1. Identidade de um Ascendente

Cada Ascendente é uma entidade persistente e única, identificada por UUID e seed próprias.

A identidade jogável é composta por:

- nome próprio procedural;
- aparência/DNA visual;
- origem: classe base ou Novato;
- Rank;
- Potencial;
- atributos;
- personalidade;
- 1–2 Traits nativos;
- perfil individual de crescimento;
- kit atual;
- evoluções escolhidas;
- especialização, quando aplicável;
- trajetória e histórico de morte quando houver.

O ID técnico nunca substitui o nome como identidade apresentada ao jogador.

## 2. Pipeline de geração

Ordem canônica:

1. seed;
2. origem: classe base ou Novato;
3. Rank;
4. Potencial;
5. atributos;
6. personalidade;
7. Traits;
8. kit inicial;
9. perfil de crescimento;
10. nome;
11. aparência procedural.

Nem todos os elementos são independentes:

- classe pesa a distribuição de atributos;
- personalidade não é determinada pela classe;
- Traits são filtrados/pesados depois de personalidade e classe;
- aparência é gerada por último e deve ser compatível com o resultado mecânico.

## 3. Rank e Potencial

Escala comum:

**D → C → B → A → S**

- **Rank:** força atual no nascimento/summon.
- **Potencial:** capacidade de crescimento futuro.

Regra conceitual:

> **Rank diz quem ele é hoje. Potencial diz o que ele pode se tornar.**

Rank e Potencial são quase independentes. D/S e S/D são válidos.

## 4. Atributos base

- Poder;
- Vitalidade;
- Agilidade;
- Foco;
- Determinação.

Escala: 0–100 por atributo.

Funções:

- **Poder:** força ofensiva e scaling de ações ofensivas.
- **Vitalidade:** HP máximo.
- **Agilidade:** velocidade de ação e reposicionamento; não reduz cooldowns.
- **Foco:** potência/qualidade de habilidades, cura, controle e dano técnico.
- **Determinação:** resistência à acumulação de Stress e pequena resistência a controles/debuffs.

Valores e fórmulas vivem em `../03-balance/BALANCE_MODEL_V0.1.md`.

## 5. Personalidade

Valores:

- Coragem;
- Prudência;
- Empatia;
- Disciplina.

Geração V1:

1. gerar valores em faixas relativamente neutras;
2. escolher uma tendência dominante;
3. escolher uma tendência fraca;
4. aplicar ajustes;
5. adicionar pequena variação.

Regras:

- Coragem e Prudência não são opostos matemáticos;
- personalidade não é uma classe escondida;
- personalidade altera pesos de decisão, não concede bônus simples de atributo.

Efeito comportamental:

- **Coragem:** mais tolerância a risco, pressão e perseguição.
- **Prudência:** mais autopreservação e preferência por posições seguras.
- **Empatia:** mais prioridade de ajudar/proteger aliados em risco.
- **Disciplina:** maior fidelidade à função, formação e comando; reduz amplificação comportamental causada por Stress.

## 6. Traits nativos

Cada Ascendente nasce com **1 ou 2 Traits**.

Regras:

- Traits criam trade-offs comportamentais;
- não são puramente bons ou ruins;
- não são exclusivos de classe;
- classe e personalidade podem alterar elegibilidade/peso, mas não determinam o resultado;
- Stress aumenta a expressão dos Traits;
- Traits adquiridos por história ficam fora do Vertical Slice.

Catálogo nativo do Slice:

### Protetor
Prioriza interceptar/proteger aliados, podendo abrir mão de oportunidades ofensivas.

### Impulsivo
Aumenta agressividade e perseguição, especialmente sob Stress, mas reduz aderência à formação.

### Cauteloso
Aumenta autopreservação e distância de ameaças, mas pode perder oportunidades de finalização.

### Teimoso
Tende a manter o alvo atual por mais tempo; melhora persistência, mas reage pior a mudanças de prioridade.

### Sobrevivente
Quando o próprio HP está baixo, aumenta fortemente comportamento defensivo, reduzindo contribuição ofensiva.

### Executor
Prioriza inimigos com HP baixo para finalizar ameaças; pode ignorar um alvo taticamente mais importante.

### Sentinela
Prefere manter posição, cobrir aliados próximos e reagir a avanços; persegue menos.

### Vingativo
Após aliado sofrer dano pesado ou morrer, aumenta temporariamente prioridade sobre o agressor responsável; pode distorcer a prioridade ideal.

### Caçador
Valoriza inimigos isolados, expostos ou de retaguarda e aceita se deslocar para alcançá-los; pode se afastar da proteção.

### Leal
Dá peso extra ao comando do jogador e à formação definida; pode reagir mais lentamente quando quebrar a ordem seria melhor.

## 7. Classes base

### 7.1 Vanguarda

Identidade:

> **Segura o espaço e impede que a luta chegue facilmente aos outros.**

**Ataque básico — Golpe de Arma**  
Ataque melee simples.

**Habilidade automática — Interceptar**  
Quando um aliado próximo está ameaçado, pode reposicionar-se para um anchor de interceptação e aumentar fortemente a chance de assumir a pressão daquele inimigo. Possui cooldown. Não é taunt global.

**Comportamento — Linha de Frente**

- valoriza ameaças próximas;
- reage a inimigos pressionando aliados;
- prefere frente/meio;
- evita abandonar totalmente a formação;
- protege personagens frágeis quando duas decisões são equivalentes.

#### Guardião

**Interceptação Guardiã**  
Interceptar também concede proteção temporária curta ao aliado interceptado, sem barra de escudo separada.

**Bastião**

- prioridade forte em proteger aliados;
- mantém posições importantes;
- reage a ameaças contra retaguarda;
- persegue menos;
- assume pressão com mais frequência.

Trade-off: menor pressão ofensiva e perseguição.

#### Devastador

**Investida Brutal**  
Transforma a resposta da Vanguarda em avanço sobre abertura/ameaça valiosa, com impacto maior e pequeno reposicionamento do alvo ou ocupação de anchor agressivo.

**Ruptura**

- valoriza inimigos frágeis acessíveis;
- busca aberturas;
- pressiona meio/retaguarda;
- insiste em finalização após romper a frente.

Trade-off: protege menos e adere menos à formação.

---

### 7.2 Atirador

Identidade:

> **Procura o alvo certo e tenta eliminá-lo antes que a luta chegue até ele.**

**Ataque básico — Disparo Preciso**  
Ataque à distância consistente.

**Habilidade automática — Mira Prioritária**  
Periodicamente executa disparo de maior impacto em alvo vulnerável/prioritário, considerando HP baixo, exposição, retaguarda e Concentrar Fogo.

**Comportamento — Linha de Tiro**

- mantém distância de ameaças melee;
- prefere meio/retaguarda;
- procura alvos frágeis/expostos;
- evita bloqueio pela linha de frente;
- reposiciona quando pressionado ou com linha de tiro ruim.

#### Franco-atirador

**Tiro de Execução**  
Mira Prioritária vira um disparo mais demorado e de alto impacto contra alvo de alto valor. Não é execute garantido.

**Paciência Letal**

- valoriza retaguarda segura;
- troca menos de alvo;
- espera boas oportunidades;
- prioriza finalizações e ameaças-chave.

Trade-off: menor mobilidade/flexibilidade e maior vulnerabilidade sob pressão melee.

#### Batedor

**Disparo em Movimento**  
Combina ataque com reposicionamento curto para melhorar ângulo, escapar de pressão ou alcançar ameaça relevante.

**Leitura de Rotas**

- procura anchors seguros com boa linha de tiro;
- reposiciona mais;
- busca ângulos contra retaguarda;
- mantém pressão constante.

Trade-off: menos burst em alvo único que o Franco-atirador.

---

### 7.3 Arcanista

Identidade:

> **Observa o campo e transforma agrupamentos inimigos em oportunidades.**

**Ataque básico — Projétil Arcano**  
Ataque mágico simples à distância.

**Habilidade automática — Ruptura Arcana**  
Atinge uma pequena área, priorizando agrupamentos e alvos de maior valor. Na classe base não aplica controle/DoT adicional.

**Comportamento — Leitura do Campo**

- prefere meio/retaguarda;
- procura agrupamentos;
- evita exposição melee;
- valoriza posições de cobertura multi-alvo;
- reposiciona quando outra posição oferece valor claramente maior.

#### Elementalista

**Convergência Elemental**  
Ruptura Arcana vira magia de área mais forte com um único efeito secundário elemental curto e legível.

**Domínio Elemental**

- procura agrupamentos com mais agressividade;
- aceita esperar por oportunidade de área;
- valoriza cobertura;
- pode aceitar maior exposição por um grande ganho multi-alvo.

Trade-off: pior contra alvos isolados e mais dependente de posicionamento.

#### Ocultista

**Marca Sombria**  
Substitui o foco em área por um debuff persistente sobre alvo valioso, com redução moderada de eficiência e pequeno dano persistente.

**Pressão Persistente**

- valoriza ameaças duráveis;
- prefere manter pressão em alvo relevante;
- considera alvos já enfraquecidos;
- busca aplicar o debuff antes de ações perigosas.

Trade-off: menos impacto imediato e menos valor em lutas muito curtas.

---

### 7.4 Suporte

Identidade:

> **Mantém o grupo funcional quando a luta começa a sair do controle.**

**Ataque básico — Pulso de Apoio**  
Ataque mágico simples, de dano baixo.

**Habilidade automática — Amparo**  
Cura moderada simples no aliado que mais precisa, considerando HP baixo, pressão, exposição e contexto de Stress.

**Comportamento — Prioridade ao Grupo**

- prefere meio/retaguarda;
- monitora aliados em risco;
- reposiciona para manter alcance;
- prioriza sobrevivência do grupo acima de dano marginal;
- evita exposição desnecessária.

#### Médico

**Atendimento de Emergência**  
Cura mais forte, prioriza estados críticos e concede breve resistência extra a dano, sem escudo separado.

**Triagem**

- identifica risco de morte;
- prioriza aliados sob foco;
- guarda intervenção para momentos críticos;
- preserva posição segura.

Trade-off: baixa contribuição ofensiva e coletiva fora da emergência.

#### Inspirador

**Impulso Inspirador**  
Buff curto em aliado relevante, aumentando eficiência temporária e reduzindo parte do Stress.

**Presença Motivadora**

- acompanha Stress do grupo;
- intervém antes de instabilidade forte;
- favorece aliados importantes para a composição;
- ajuda a manter o grupo funcional sob pressão.

Trade-off: menor capacidade de salvar alguém em risco imediato que o Médico.

## 8. Novato

Novato não é uma quinta classe normal.

Características:

- menos especializado;
- mais aberto a influência de personalidade/Traits;
- risco/recompensa;
- não é objetivamente melhor que classes base.

**Ataque básico — Golpe Instintivo**  
Ataque simples de desempenho mediano.

**Habilidade automática — Adrenalina**  
Sob pressão relevante, aumenta temporariamente velocidade de ação/reposicionamento. Não decide a ação; apenas intensifica o comportamento escolhido pela Utility AI.

**Comportamento — Sem Caminho**  
Possui menos peso de classe na Utility AI, aumentando influência relativa de personalidade e Traits. Tende a frente/meio, sem função rígida.

Antes do Despertar não possui cura, magia de área, Interceptar nem precisão especializada de Atirador.

### Despertar

No L10:

- recebe 2–3 opções entre Vanguarda, Atirador, Arcanista e Suporte;
- opções são influenciadas por atributos e personalidade;
- classes especiais não existem no Vertical Slice;
- escolha é permanente.

Após despertar, segue a progressão da classe escolhida.

## 9. Nomes

Na V1, nomes vêm de **catálogo curado de nomes inteiros** compatíveis com o universo. Não usar geração por sílabas como baseline.

Objetivos:

- boa legibilidade;
- evitar nomes ruins/estranhos;
- reforçar memória e apego;
- evitar repetição excessiva.
