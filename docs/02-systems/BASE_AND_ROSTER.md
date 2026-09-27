# Base e Roster

**Status:** FROZEN para funções e estados. Layout visual final é DEFERRED para UX/Visual Bible.

## 1. Funções mínimas da Base

A Base do Vertical Slice possui somente estas funções:

1. **Roster/Formação**;
2. **Invocação**;
3. **Convergência**;
4. **Torre**;
5. **recuperação passiva de Cansaço** para quem ficou na Base.

Não existem na V1:

- enfermaria;
- treinamento manual;
- taverna;
- dormitórios como sistema;
- crafting;
- loja;
- missões de Base;
- relações profundas;
- Hall dos Caídos jogável.

O save deve, porém, preservar dados suficientes dos mortos para o Hall dos Caídos futuro.

## 2. Base é hub, Roster é função

A Base não deve virar sequência de menus aninhados. Funcionalmente, ela centraliza as decisões entre expedições.

O layout exato será definido depois, mas a arquitetura de UX deve evitar:

`menu → submenu → submenu → botão`.

## 3. Formação

O jogador seleciona **1–5 Ascendentes** e escolhe quais dos **7 anchors** ocupam.

Não existe restrição rígida de classe por posição.

Exaustos não podem ser selecionados.

Ascendentes com evolução de marco pendente também não podem voltar à Torre até resolverem a escolha.

Avisos de risco não bloqueiam decisões válidas, por exemplo:

- party com apenas 1–2 membros;
- múltiplos membros Muito Cansados.

## 4. Informação mínima por Ascendente na Base

Na leitura rápida de roster/formação, cada Ascendente deve expor:

- nome/retrato;
- classe + nível;
- estado de Cansaço;
- se está ou não na formação;
- anchor atual quando estiver na formação;
- evolução pendente quando existir;
- indisponibilidade relevante.

HP e Stress não são prioridade nessa tela porque:

- HP volta ao máximo na Base na V1;
- Stress volta a 0.

O valor numérico 0–100 de Cansaço pode ficar na ficha detalhada; a leitura rápida usa o estado textual.

## 5. Estados de Cansaço

- Descansado: 0–24;
- Cansado: 25–49;
- Muito Cansado: 50–74;
- Exausto: 75–100.

Consequências numéricas vivem no Balance Model.

## 6. Recuperação de Cansaço

Ascendentes que ficam na Base recuperam Cansaço conforme a equipe ativa conclui encontros.

Baseline congelada:

- −5 por encontro concluído pela equipe ativa;
- máximo de −20 naquela expedição.

Recuo/derrota não anulam a recuperação já gerada por encontros realmente concluídos.

Entrar na Torre e recuar sem concluir encontro não recupera nada.

## 7. Proteção contra softlock por Cansaço

A party pode ter 1–5 membros, portanto não existe recuperação automática só porque há menos de 5 aptos.

A recuperação de segurança só acontece quando:

- existem Ascendentes vivos no roster;
- nenhum deles está apto exclusivamente porque todos estão Exaustos.

Nesse caso, recupera-se apenas o mínimo necessário para permitir que **1 Ascendente** entre na Torre.

Não concede:

- XP;
- recurso de summon;
- progressão de Torre;
- qualquer benefício adicional.

## 8. Evoluções pendentes

Quando um personagem volta com marco pendente:

- recebe indicador forte de evolução disponível;
- pode ficar na Base indefinidamente;
- não pode subir novamente até escolher;
- a escolha é permanente;
- autosave imediato após a decisão.

Isso vale para:

- L5;
- L10;
- L15;
- L20;
- Despertar de Novato.

## 9. Ordenação do roster

Ordenação padrão aprovada:

1. em formação;
2. prontos;
3. cansados;
4. muito cansados;
5. evolução pendente;
6. exaustos.

Filtros adicionais podem ser adicionados no UX final se necessário, mas não são essenciais para um roster máximo de 15.

Não criar um “power score” único que diga qual Ascendente é melhor.

## 10. Sinalização de estado da Base

A Base deve conseguir sinalizar pendências sem exigir múltiplas telas, por exemplo:

- Roster/Formação → quantidade selecionada;
- Invocação → recurso disponível/custo;
- evoluções pendentes → quantidade;
- Torre → próximo andar.

Prioridade funcional de atenção após uma expedição:

1. evolução pendente;
2. party incompleta/indisponível;
3. Cansaço;
4. recurso suficiente para summon;
5. próximo andar.

## 11. Reações contextuais

Decisões de alto risco podem disparar falas curtas de Ascendentes com base em personalidade/Traits.

Exemplo importante: enviar apenas 1 Ascendente para a Torre.

As falas vêm de catálogo curado por contexto/perfil; não existe IA generativa em runtime.

Essas falas são apresentação e não alteram mecanicamente a escolha.
