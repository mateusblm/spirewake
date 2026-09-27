# Source of Truth

**Status:** FROZEN

## Objetivo

Evitar regras concorrentes entre documentos e impedir que agentes implementem rascunhos antigos.

## Precedência

Quando houver conflito, use a seguinte ordem:

1. decisão mais recente registrada como substituição explícita em `DECISION_REGISTER.md`;
2. documento canônico dono daquele sistema;
3. `BALANCE_MODEL_V0.1.md` para valores numéricos;
4. `PRODUCT_BIBLE.md` para intenção de produto;
5. backlog apenas como referência futura, nunca como especificação.

Um resumo duplicado em outro documento não substitui o dono canônico da regra.

## Status aceitos

### FROZEN
A regra funcional está aprovada. Implementar como escrita.

### BALANCE_V0_1
A estrutura está aprovada e pode ser implementada. Valores explicitamente marcados como tunáveis podem mudar em playtest sem reabrir o design conceitual.

### DEFERRED
Decisão adiada. Não inventar nem implementar.

### OUT_OF_SCOPE
Fora do Vertical Slice.

## Controle de mudanças

Quando uma decisão mudar:

1. alterar primeiro o documento dono da regra;
2. registrar a substituição no `DECISION_REGISTER.md` quando houver risco de conflito com uma regra antiga;
3. atualizar documentos que contenham apenas resumo/referência;
4. só depois alterar implementação e testes.

Não manter duas regras válidas para o mesmo comportamento.
