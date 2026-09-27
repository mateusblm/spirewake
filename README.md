# Spirewake

Repositório de produto e implementação do Spirewake.

## Estado atual

O design funcional do Vertical Slice está congelado. A próxima fase é transformar as regras aprovadas em direção visual, UX final e arquitetura técnica antes de abrir as sprints de implementação.

Ordem de trabalho atual:

1. Gameplay funcional — **congelado**.
2. Documentação canônica — **este pacote**.
3. Visual Bible + Golden Rig.
4. UX final das telas e fluxos.
5. Arquitetura técnica.
6. Estrutura de execução para Claude/Codex.
7. Sprints.
8. Implementação e playtest.

## Por onde começar

- Regras para agentes: [`AGENTS.md`](AGENTS.md)
- Índice dos documentos: [`docs/README.md`](docs/README.md)
- Fonte de verdade e precedência: [`docs/00-governance/SOURCE_OF_TRUTH.md`](docs/00-governance/SOURCE_OF_TRUTH.md)
- Produto: [`docs/01-product/PRODUCT_BIBLE.md`](docs/01-product/PRODUCT_BIBLE.md)
- Escopo do Vertical Slice: [`docs/01-product/VERTICAL_SLICE_SCOPE.md`](docs/01-product/VERTICAL_SLICE_SCOPE.md)

## Regra central

> O agente implementa uma especificação. O agente não inventa uma especificação.

Ideias novas não entram no código automaticamente. Elas vão para backlog e só passam a ser escopo depois de aprovação e atualização da documentação canônica.
