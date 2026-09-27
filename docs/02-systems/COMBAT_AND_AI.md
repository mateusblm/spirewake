# Combate e Utility AI

**Status:** FROZEN para regras funcionais; números finos em `BALANCE_MODEL_V0.1.md`.

## 1. Modelo de combate

- auto-battler;
- mobile portrait;
- arena em perspectiva 3/4;
- sem controle direto de ações individuais;
- sem pathfinding livre;
- posicionamento baseado em anchors;
- decisões por Utility AI;
- personalidade, Traits, Stress, contexto e comando alteram pesos de decisão.

## 2. Party e formação

A party pode ter **1–5 Ascendentes**.

Há **7 anchors lógicos** disponíveis:

- frente: F1, F2;
- meio: M1, M2, M3;
- retaguarda: T1, T2.

O jogador escolhe livremente:

- quais 1–5 Ascendentes entram;
- quais 1–5 dos 7 anchors ficam ocupados;
- quem começa em cada anchor.

Não há trava por classe.

Inimigos usam estrutura espelhada.

A disposição visual final não deve parecer uma grade rígida; os anchors são lógica interna e serão posicionados de forma assimétrica/natural na arena 3/4.

## 3. Movimento

Após o combate começar, o jogador não rearranja manualmente a formação.

Reposicionamentos acontecem por:

- necessidade tática;
- habilidade;
- comportamento de classe;
- personalidade;
- Trait;
- comando.

Movimentos devem ser curtos e legíveis. Personagens tendem a retornar a uma posição válida após ações temporárias.

O sistema deve tratar os anchors como um pequeno grafo de vizinhança, permitindo relações de proximidade/interceptação sem pathfinding livre.

## 4. Targeting por classe

### Vanguarda
Prioriza ameaças próximas, proteção e interceptação.

### Atirador
Prioriza alvos frágeis/expostos e ameaças de retaguarda.

### Arcanista
Prioriza valor de área/controle e agrupamentos.

### Suporte
Prioriza aliados em risco e manutenção da equipe.

### Novato
Possui menos peso de classe; personalidade/Traits têm influência relativamente maior.

O resultado final sempre pode ser alterado por contexto, Stress, Traits e comando.

## 5. Camadas da Utility AI

A decisão deve ser composta por estas camadas:

1. ações disponíveis;
2. contexto atual do combate;
3. função/classe;
4. comando tático ativo;
5. personalidade;
6. Traits;
7. Stress e Disciplina modulando a expressão individual.

Regra conceitual:

> **Classe/contexto define a decisão-base. Personalidade inclina. Trait cria uma tendência reconhecível. Stress amplifica personalidade/Traits.**

## 6. Eixos comportamentais

A Utility AI pode representar personalidade por pelo menos quatro eixos internos:

- agressão/risco;
- autopreservação;
- proteção de aliados;
- aderência à função/formação.

Mapeamento:

- Coragem → mais agressão/tolerância a risco;
- Prudência → mais autopreservação/posição segura;
- Empatia → mais proteção/ajuda a aliados;
- Disciplina → mais aderência à função/formação/comando e menos desvio extra causado por Stress.

## 7. Stress e comportamento

Stress não cria ações novas. Ele aumenta o peso das tendências já existentes.

Estados:

- Estável 0–24;
- Pressionado 25–49;
- Abalado 50–74;
- Crítico 75–100.

Com Stress baixo, classe/contexto dominam. Em estados mais altos, personalidade e Traits ganham influência. Disciplina reduz apenas a amplificação provocada por Stress; não apaga a personalidade normal.

Fórmulas e multiplicadores ficam no Balance Model.

## 8. Comandos táticos

Há **1 única carga de comando por andar inteiro**.

Usar qualquer comando consome a carga.

Duração-base de todos os comandos: **8 segundos**.

Abrir o comando pode pausar brevemente a luta apenas para a escolha. Não existe pausa livre para análise contínua.

### Concentrar Fogo

- jogador escolhe um inimigo;
- aumenta fortemente prioridade daquele alvo para Ascendentes que conseguem engajá-lo;
- necessidades críticas ainda podem superar o comando.

### Manter Formação

- aumenta prioridade de defesa/proteção;
- reduz quebras de posição;
- reduz pressão ofensiva.

### Avanço Total

- aumenta agressividade e prioridade de finalização;
- aumenta exposição/risco.

Comandos alteram pesos da IA; nunca viram controle direto.

## 9. Tipos de dano

A V1 possui apenas:

- **Físico** → mitigado por Armadura;
- **Arcano** → mitigado por Resistência Arcana.

Não há true damage como sistema-base, penetração, crítico aleatório, chance de erro, dodge aleatório, block aleatório nem variação aleatória de dano na V1.

## 10. Fórmula geral de habilidades

Cada habilidade usa seus próprios coeficientes:

`Efeito bruto = Valor Base + Poder×coefP + Foco×coefF`

Isso evita multiplicações globais entre atributos.

A defesa usa a família:

`Dano final = Dano bruto × 100 / (100 + Resistência relevante)`

Coeficientes específicos ainda são Balance v0.1/playtest-tunable.

## 11. Agilidade

Agilidade aumenta:

- velocidade de ação;
- velocidade de reposicionamento.

Agilidade **não reduz cooldown de habilidade**.

Fórmula-base e intervalos por classe ficam no Balance Model.

## 12. HP, Stress e Cansaço

### HP

- sobrevivência imediata;
- persiste entre encontros do andar;
- HP 0 = morte permanente;
- restaura totalmente ao retornar à Base na V1.

### Stress

- estabilidade comportamental durante a expedição;
- persiste entre encontros;
- zera na Base;
- nasce de acontecimentos.

### Cansaço

- desgaste entre expedições;
- persiste na Base;
- incentiva rotação;
- nasce de uso;
- Exausto não entra na Torre.

Regra conceitual:

> **Stress nasce de acontecimentos. Cansaço nasce de uso.**

## 13. Vitória e derrota

### Vitória

- todos os inimigos mortos;
- pelo menos 1 Ascendente vivo.

### Derrota

- 0 Ascendentes vivos.

Se o último inimigo e o último Ascendente morrerem na mesma resolução, conta como derrota.

Mortos não podem ser substituídos por reservas no mesmo andar.
