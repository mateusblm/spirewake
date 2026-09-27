# Changelog de Design

## 0.4 — Gameplay Functional Freeze

Consolidação da fase de design funcional do Vertical Slice em documentos canônicos separados por domínio.

Principais mudanças em relação ao Product Bible v0.3:

- summon/economia fechados;
- Convergência definida, incluindo tabelas de Rank/Potencial;
- Base mínima fechada;
- formação de 7 anchors;
- party alterada para 1–5;
- 10 andares do Vertical Slice fechados;
- 6 inimigos, 5 templates, 3 Elites e Boss definidos;
- First Call definido;
- XP, níveis, crescimento e evoluções menores definidos;
- kits das classes, Novato e especializações definidos;
- arquitetura comportamental de personalidade/Traits fechada;
- catálogo de 10 Traits fechado;
- matemática estrutural de combate definida;
- Stress e Cansaço numerizados;
- permadeath, autosave, retorno à Base e fluxo de expedição definidos;
- revisitas procedurais determinísticas definidas;
- classes especiais removidas do Vertical Slice;
- antigas regras conflitantes de wipe/Cansaço substituídas.

O arquivo antigo `Spirewake_Product_Bible_v0.3.md` deve ser considerado **superseded** pela estrutura canônica atual.

## 0.4.1 — P2.4B-0 Golden Rig Lab (2026-09-18)

Primeira implementação do Golden Rig Lab em sandbox isolada (`sandbox/golden_rig_lab/`, Godot 4.7.2).

- contratos P1.5 copiados para `docs/05-visual/` (`P1_VANGUARD_RIG_SPEC_v2.md`, `agent-contract/*`, `manifests/vanguard_sword_shield.rig.json`);
- pacote P2.4B copiado para `docs/05-visual/p2_4b/`;
- cena canônica `VanguardSwordShieldAppearance` gerada a partir do manifest P1.5 (11 bones, 6 sockets) e verificada em runtime (GR022/GR023);
- 10 candidatos `armor_blackguard_01` FRONT_3Q montados só por metadata (pivot/canvas_offset/scale/z);
- relatório e screenshots de review em `docs/05-visual/p2_4b/P2_4B_0_LAB_REPORT.md` e `review_p2_4b_0/`;
- resultado: Lab aprovado para review; montagem FRONT_3Q **não** passa (antebraços são JPEG sem alpha; braços e coxas desenhados fora do ângulo de rest do rig). Nenhum anchor/bone do rig foi alterado.

## 0.4.2 — P2.4B-0 aprovado; pass P2.4B-1 aberto (2026-09-18)

- Golden Rig Lab (P2.4B-0) aprovado e congelado; rig P1.5 intacto.
- Decisões D1–D6 registradas em `docs/05-visual/p2_4b/P2_4B_DECISIONS.md`.
- Pass de correção de arte P2.4B-1 aberto: brief em `P2_4B_1_REGENERATION_BRIEF.md`, templates derivados do manifest em `regen_templates_p2_4b_1/`, intake em `sandbox/golden_rig_lab/tools/intake_check.py`, comparação antes/depois em `tools/compare_validation.py`.
- Lab passa a exportar `…__validation.json` (baseline "antes" em `review_p2_4b_0/`).
