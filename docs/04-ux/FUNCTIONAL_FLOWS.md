# Fluxos Funcionais de UX

**Status:** FROZEN para sequência e informação. Layout, motion, audio e composição visual são DEFERRED.

## 1. Princípio geral

A UX do Spirewake deve comunicar estados e consequências sem transformar o jogo em planilha. O jogador precisa entender rapidamente:

- quem é cada Ascendente;
- quem está apto;
- quem precisa descansar;
- quem evoluiu;
- o risco do próximo encontro;
- o que foi perdido;
- o que foi ganho.

## 2. First Call

Ao iniciar novo save:

1. executar o ritual inicial;
2. revelar os 5 Ascendentes individualmente;
3. permitir que o jogador veja identidade essencial de cada um;
4. conduzir para a Base com roster inicial completo.

O First Call usa regras próprias de composição, mas visualmente deve reforçar a mesma fantasia do summon normal.

## 3. Invocação normal

Sequência funcional:

1. jogador confirma o gasto;
2. UI reduz ruído e ritual começa;
3. silhueta aparece;
4. aparência completa é revelada;
5. nome aparece;
6. classe/Novato;
7. Rank;
8. Potencial;
9. Traits;
10. tela final resumida;
11. opção de ver detalhes ou continuar.

A revelação de Rank e Potencial é separada deliberadamente.

Não mostrar todos os atributos como primeira leitura. Eles ficam em detalhes.

Ranks altos podem usar feedback audiovisual mais forte. O pipeline visual deve permanecer compartilhado.

## 4. Convergência

Antes da confirmação:

- mostrar os 2 Ascendentes selecionados;
- mostrar que ambos serão perdidos permanentemente;
- mostrar odds completas de Rank;
- mostrar odds completas de Potencial;
- mostrar eventual viés de origem/linhagem;
- deixar claro que o resultado é um novo Ascendente L1.

Após confirmar:

1. travar a decisão;
2. persistir/autosave;
3. determinar resultado;
4. executar revelação do novo Ascendente usando linguagem próxima à invocação;
5. voltar ao roster com 1 vaga líquida liberada.

## 5. Base — leitura rápida

A Base deve responder em poucos segundos:

- quem está na party;
- quem está Descansado/Cansado/Muito Cansado/Exausto;
- quem possui evolução pendente;
- quantos estão selecionados;
- se há recurso suficiente para summon;
- qual é o próximo andar.

Cada Ascendente no roster expõe:

- nome/retrato;
- classe + nível;
- estado de Cansaço;
- estado de formação/anchor;
- evolução pendente;
- indisponibilidade relevante.

HP e Stress não são prioridade na Base.

## 6. Formação

O jogador seleciona 1–5 Ascendentes e escolhe 1–5 dos 7 anchors.

Avisos de risco são informativos, não bloqueantes.

Exemplos:

- “Equipe com apenas 2 Ascendentes. Alto risco.”
- “3 membros estão Muito Cansados.”

Quando a decisão for dramaticamente arriscada, personagens podem emitir falas curtas de catálogo curado conforme personalidade/Traits.

Exemplo: enviar 1 Ascendente sozinho.

## 7. Entrada na Torre

Fluxo:

1. abrir Torre;
2. escolher próximo andar ou revisita;
3. revisar party/formação;
4. mostrar quantidade prevista de encontros e alertas relevantes;
5. confirmar;
6. bloquear formação para aquela expedição;
7. gerar/persistir sequência quando aplicável;
8. entrar no primeiro encontro.

## 8. Prévia de encontro

Antes de lutar, mostrar de forma curta:

- tipo: Normal/Elite/Boss;
- quantidade de inimigos;
- papéis/composição;
- modificador Elite quando houver.

Antes do Boss:

- aviso explícito de Boss;
- aviso explícito de que não haverá recuo após iniciar.

## 9. Combate

Durante combate:

- HP é a informação numérica mais explícita;
- Stress deve ser percebido principalmente por estado/ícone/feedback, sem poluir a arena;
- telegraphs de ataques importantes precisam ser claros;
- inimigos e papéis precisam ser reconhecíveis;
- comando tático deve estar legível e mostrar se a carga 1/1 ainda existe.

Ao abrir um comando, a luta pode pausar brevemente para escolha. Não há pausa livre contínua.

## 10. Intervalo entre encontros

Após resolver um encontro, mostrar rapidamente:

- sobreviventes;
- mortos;
- HP atual;
- Stress atual;
- estado da carga de comando;
- prévia do próximo encontro.

Ações disponíveis:

- Continuar;
- Recuar.

Não existe no intervalo:

- cura manual;
- consumível;
- troca de roster;
- reserva;
- reorganização manual da formação.

A pergunta central é:

> **“Com o estado atual dessa equipe, vale arriscar continuar?”**

## 11. Retorno à Base — ordem emocional

Sequência congelada:

### 1. Sobreviventes retornam
Primeiro mostrar quem voltou, antes de números e recompensas.

### 2. Mortos da expedição
Se houver morte, dar etapa própria antes de qualquer recompensa.

Mostrar pelo menos:

- nome;
- retrato;
- nível;
- classe;
- frase curta de encerramento/contexto.

### 3. Progressão dos sobreviventes

- XP;
- níveis ganhos;
- evoluções pendentes.

### 4. Estado pós-expedição

- Cansaço final dos sobreviventes;
- recuperação de quem ficou na Base.

Stress não precisa de destaque porque já zera.

### 5. Recompensas

- recurso de summon;
- bônus Elite;
- bônus Boss;
- recompensa de conclusão.

### 6. Progresso da Torre

Se first clear:

- andar concluído;
- próximo andar desbloqueado.

Em revisita, apenas registrar conclusão sem alterar máximo se não houver avanço.

### 7. Retorno visual ao hub

Depois disso o jogador pode evoluir, mudar formação, invocar, convergir ou subir novamente.

## 12. Variação por resultado

### Conclusão
Tom de conquista e avanço.

### Recuo
Tom de sobrevivência/abandono do objetivo; deixar claro que os +40 de conclusão não foram obtidos.

### Derrota
Foco primeiro nos mortos e depois no que foi preservado dos encontros anteriores.

## 13. Evoluções pendentes

Na Base, o indicador deve ser forte e levar diretamente à decisão correspondente.

A escolha não deve ser resolvida por pop-up durante a Torre.

## 14. Cansaço

Na preparação, usar estados textuais claros:

- Descansado;
- Cansado;
- Muito Cansado;
- Exausto.

Não obrigar o jogador a memorizar apenas cores.

A ficha detalhada pode mostrar o valor 0–100.

## 15. Regra emocional de morte

Se houve morte, ela aparece **antes** das recompensas.

Não iniciar o retorno com “+40 recurso” quando o jogador acabou de perder um Ascendente.

Evitar múltiplos pop-ups e sequências de botões “OK”. A apresentação pode avançar por toque e culminar em um único “Continuar”.
