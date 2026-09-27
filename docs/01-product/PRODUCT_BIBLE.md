# Spirewake — Product Bible

**Versão:** 0.4 — Gameplay Functional Freeze  
**Status:** FROZEN para produto/gameplay do Vertical Slice

## 1. Visão do produto

Spirewake é um jogo mobile portrait de fantasia sombria focado em gerenciar Ascendentes únicos enviados para subir uma Torre perigosa.

O jogador não controla diretamente cada ação. Ele monta o roster, define a formação, escolhe quando interferir e convive com as consequências de personagens autônomos, progressão persistente e permadeath.

A fantasia central é:

> **convocar pessoas únicas, aprender quem elas são, colocá-las em risco e carregar as histórias que surgem das decisões e perdas.**

## 2. Pilares

### Ascendentes realmente individuais
Cada Ascendente combina nome, aparência, Rank, Potencial, atributos, personalidade, Traits, perfil de crescimento, classe, evoluções e trajetória.

### Auto-battle legível
O jogador deve conseguir entender por que uma equipe venceu, perdeu, protegeu alguém, se expôs ou tomou uma decisão ruim.

### Autonomia com personalidade
Classe/contexto definem a decisão-base; personalidade e Traits inclinam essa decisão; Stress aumenta a expressão dessas tendências.

### Permadeath com peso
HP 0 significa morte permanente. A morte custa a pessoa, não uma pilha adicional de punições econômicas.

### Gestão de roster
O jogador precisa decidir quem sobe, quem descansa, quem evolui, quem é convergido e como 1–5 Ascendentes são posicionados em 7 anchors.

### Torre como pressão recorrente
Cada andar é uma mini-expedição linear. HP e Stress persistem dentro do andar, Cansaço persiste entre expedições e o jogador pode recuar entre encontros.

## 3. Core loop

**Base → preparar roster/formação → escolher andar → expedição com 3–5 encontros → decidir continuar/recuar → sofrer ganhos/perdas → retorno obrigatório à Base → evoluir/invocar/convergir → nova subida.**

## 4. O que o Vertical Slice precisa provar

1. Invocar um Ascendente é um momento interessante e memorável.
2. Assistir uma equipe lutar autonomamente é divertido e compreensível.
3. Personagens da mesma classe parecem diferentes por personalidade, Traits, crescimento e decisões.
4. Formação e composição importam.
5. O comando tático único cria uma decisão real sem transformar o jogo em controle direto.
6. Perder um Ascendente importa.
7. Cansaço e roster geram rotação sem virar sistema de energia mobile.
8. Dez andares conseguem sustentar progressão, summons, Elites, revisitas e um Boss sem inflar o escopo.

## 5. Vertical Slice

O Vertical Slice possui **10 andares** e termina no primeiro Boss, o **Guardião do Limiar**, no andar 10.

Conteúdo mínimo:

- 4 classes base + Novato;
- 8 especializações;
- 6 inimigos comuns;
- 5 templates de composição inimiga;
- 3 modificadores de Elite;
- 1 Boss;
- 10 Traits nativos;
- 30 evoluções menores (6 genéricas + 6 por classe base);
- summon individual;
- Convergência;
- roster máximo 15;
- Base funcional mínima;
- revisitas procedurais determinísticas;
- progressão até L20 suportada, embora L20 não seja esperado naturalmente nos 10 andares.

## 6. Direção de produção

### Papéis

- **Mateus:** product owner e decisão final.
- **ChatGPT:** produto, especificações, direção visual, assets e revisão.
- **Claude:** UI/UX, composição visual e implementação visualmente pesada.
- **Codex:** arquitetura, sistemas de domínio, testes, refactors e tarefas determinísticas.

### Regra de execução

> **O agente implementa uma especificação. O agente não inventa uma especificação.**

Ideias novas vão para backlog. Nenhum agente deve aumentar o escopo durante implementação.

## 7. Direção de design

- mobile portrait;
- dark fantasy estilizado;
- personagens SD/chibi sérios, não infantis;
- combate em arena 3/4 com anchors estáveis;
- auto-battle, sem pathfinding livre;
- determinismo onde RNG afeta decisões persistentes;
- sem IA generativa em runtime;
- data-driven sempre que isso facilitar expansão sem refatorar o núcleo.

## 8. Fora do Vertical Slice

Não implementar sem nova decisão explícita:

- PvP;
- multiplayer;
- guildas;
- equipamentos/loot individual;
- crafting;
- construção complexa de Base;
- romance;
- relações profundas;
- memória narrativa complexa;
- IA generativa em runtime;
- classes especiais;
- árvores gigantes de habilidades;
- energia baseada em tempo real;
- movimento livre/pathfinding complexo;
- dezenas de classes;
- dezenas de instalações de Base;
- Hall dos Caídos jogável completo;
- sistemas econômicos paralelos.

## 9. Estado do projeto

### Congelado
Produto, gameplay funcional, progressão, economia mínima, combate, Torre, Base, permadeath e regras de geração/revisita.

### Próxima fase
Visual Bible + Golden Rig, depois UX final, arquitetura técnica, sprints e implementação.
