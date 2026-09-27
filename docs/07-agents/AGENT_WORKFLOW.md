# Workflow para Claude e Codex

**Status:** FROZEN como processo de trabalho inicial.

## 1. Princípio

> **O agente implementa uma especificação. O agente não inventa uma especificação.**

## 2. Responsabilidades preferenciais

### Claude
Priorizar:

- UI/UX;
- composição visual;
- integração de assets;
- telas;
- iteração baseada em screenshots;
- tarefas onde julgamento visual é central.

### Codex
Priorizar:

- arquitetura;
- domínio;
- sistemas de gameplay;
- persistência;
- deterministic RNG;
- testes;
- refactors;
- automação;
- tarefas mecânicas/previsíveis.

A separação não é absoluta; a sprint pode atribuir diferente quando houver motivo claro.

## 3. Leitura por tarefa

Antes de alterar código:

1. `AGENTS.md` da raiz;
2. `docs/00-governance/SOURCE_OF_TRUTH.md`;
3. `docs/00-governance/DECISION_REGISTER.md`;
4. documento dono do sistema;
5. Balance Model se houver números;
6. restrições técnicas.

## 4. Proibido

Sem aprovação explícita, o agente não deve:

- criar feature nova;
- alterar regra de produto para “facilitar implementação”;
- criar moeda/recurso novo;
- adicionar classe/skill/trait não especificado;
- mudar odds;
- tornar uma decisão não determinística;
- implementar item de backlog;
- aumentar escopo de uma sprint.

## 5. Lacunas

Se a implementação exigir uma regra ausente:

- registrar exatamente o caso;
- mostrar onde a documentação não cobre;
- sugerir opções se útil;
- não selecionar uma delas silenciosamente.

## 6. Balanceamento

Valores `BALANCE_V0_1` podem ser parametrizados desde o início.

Não “corrigir” valores por intuição durante implementação. Alterações de balanceamento devem ser rastreáveis e preferencialmente acompanhadas por teste/telemetria/playtest.

## 7. Definition of Done futura

Cada tarefa de sprint deverá possuir:

- documentos canônicos de referência;
- comportamento esperado;
- casos limite;
- critérios de aceitação;
- testes esperados;
- assets/dependências;
- itens explicitamente fora da tarefa.

O template será criado quando as sprints forem abertas.
