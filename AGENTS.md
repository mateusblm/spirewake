# AGENTS.md — Spirewake

Este arquivo é obrigatório para qualquer agente que trabalhe no projeto.

## Regra principal

**Implemente a especificação. Não invente a especificação.**

Se uma decisão necessária não estiver documentada, pare a implementação daquela parte e registre a dúvida. Não escolha silenciosamente um comportamento por conta própria.

## Leitura obrigatória antes de uma tarefa

1. `docs/00-governance/SOURCE_OF_TRUTH.md`
2. `docs/00-governance/DECISION_REGISTER.md`
3. O documento canônico do sistema que será alterado.
4. `docs/03-balance/BALANCE_MODEL_V0.1.md` quando a tarefa tocar números de gameplay.
5. `docs/06-technical/TECHNICAL_CONSTRAINTS.md` quando a tarefa tocar implementação.

## Precedência

A precedência entre documentos está definida em `SOURCE_OF_TRUTH.md`. Não use rascunhos, versões antigas ou conteúdo de backlog como regra implementável.

## Status de decisões

- **FROZEN**: deve ser implementado como especificado.
- **BALANCE_V0_1**: arquitetura/regra está válida, mas números marcados como tunáveis podem mudar por playtest.
- **DEFERRED**: não implementar ainda.
- **OUT_OF_SCOPE**: explicitamente fora do Vertical Slice.

## Mudanças de produto

Um agente não deve transformar uma sugestão técnica em decisão de produto. Caso descubra uma lacuna:

1. descreva o problema;
2. proponha opções separadamente;
3. não altere a regra canônica;
4. aguarde aprovação;
5. só então atualize a documentação e o código.

## Determinismo

Sistemas procedurais, ofertas de evolução, revisitas, summons e demais decisões pseudoaleatórias relevantes devem respeitar a seed persistida. Recarregar o jogo não deve rerrolar uma decisão já materializada e salva.

## Escopo

Não adicionar equipamentos, crafting, relações profundas, PvP, multiplayer, classes especiais, IA generativa em runtime ou outros sistemas listados como futuros sem uma decisão explícita de produto.
