# Restrições Técnicas Conhecidas

**Status:** FROZEN apenas para restrições já decididas. Arquitetura detalhada é DEFERRED.

## 1. Plataforma e engine

Baseline atual do projeto:

- Godot 4.7.2;
- mobile portrait;
- referência de composição: 720×1280;
- compatibilidade mobile deve ser prioridade desde o Vertical Slice.

## 2. Determinismo

O projeto precisa suportar RNG determinístico para sistemas persistentes.

A seed deve permitir reproduzir, quando necessário:

- geração de Ascendentes;
- First Call;
- ofertas de evolução;
- revisitas da Torre;
- resultado de Convergência;
- demais decisões procedurais persistidas.

Recarregar o jogo não deve funcionar como reroll de uma decisão já materializada e salva.

## 3. Save

O save deve ser versionado e preparado para migração.

Requisitos funcionais já congelados:

- UUID persistente por Ascendente;
- seed persistente;
- roster;
- mortos/histórico;
- progresso máximo da Torre;
- expedição em andamento;
- sequência procedural persistida;
- estado RNG suficiente;
- XP/nível/evoluções;
- Rank/Potencial/atributos;
- personalidade/Traits;
- HP/Stress/Cansaço quando aplicável;
- carga de comando;
- recursos de summon;
- origem como `FIRST_CALL` quando aplicável.

Formato final e schema técnico serão definidos na arquitetura.

## 4. Data-driven

Evitar hardcode de conteúdo quando o sistema já foi projetado para expansão.

Particularmente:

- habilidades possuem IDs/recursos próprios;
- classes referenciam habilidades;
- evoluções são catálogo de dados;
- Traits são catálogo de dados;
- inimigos e templates são dados;
- andares/revisitas são dados/regras de geração;
- distribuições de summon/Convergência são dados de balanceamento.

## 5. Separação de responsabilidades

A implementação deve preservar a separação conceitual:

- **Skill** = o que pode ser feito;
- **Behavior/Utility AI** = quando tende a fazer;
- **Personality/Traits** = como o indivíduo altera pesos;
- **UI** = apresentação/entrada, não regra de domínio.

A arquitetura concreta ainda será desenhada; esta separação não autoriza criar classes finais agora.

## 6. Combate

Restrições:

- sem pathfinding livre no Vertical Slice;
- movimento por anchors e relações de vizinhança;
- sem runtime IK complexo como dependência central;
- sem RNG não determinístico para crit/miss/dodge/block porque esses sistemas não existem na V1;
- comando tático é alteração temporária de pesos da IA, não controle direto.

## 7. IA generativa

Não usar LLM/IA generativa em runtime para:

- falas;
- personalidade;
- combate;
- geração de nomes;
- decisões de NPC.

Falas contextuais usam catálogo curado.

## 8. Autosave

Pontos mínimos obrigatórios já definidos no design:

- início de expedição procedural;
- fim de cada encontro;
- recuo;
- conclusão/derrota;
- summon;
- Convergência antes da revelação;
- evolução/Despertar/especialização.

## 9. Arquitetura ainda pendente

Não congelado ainda:

- módulos/pastas de código finais;
- serviços/domínios concretos;
- eventos internos;
- schema final de save;
- formato final dos recursos de dados;
- estratégia de testes;
- pipeline de conteúdo;
- nomenclatura técnica final.

Esses pontos serão definidos na fase de arquitetura, usando os documentos de gameplay como entrada obrigatória.
