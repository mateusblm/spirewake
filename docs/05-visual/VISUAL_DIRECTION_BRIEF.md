# Visual Direction Brief

**Status:** FROZEN apenas para direção macro. Visual Bible detalhada é DEFERRED.

## 1. Direção aprovada

- mobile portrait;
- dark fantasy estilizado;
- personagens SD/chibi sérios, não infantis/fofos;
- proporção-alvo aproximada de 3 cabeças de altura;
- silhuetas fortes;
- leitura rápida em tela pequena;
- arena de combate em perspectiva 3/4;
- estética coerente com fantasia sombria, sem excesso de microdetalhe ilegível.

## 2. Personagens procedurais

A direção é **meso-modular / paper-doll**, evitando dois extremos:

- microcomponentes demais, que geram encaixes quebrados e manutenção difícil;
- blocos gigantes, que deixam animação rígida e reduzem variedade.

Camadas conceituais possíveis:

- corpo;
- pele/rosto;
- cabelo traseiro;
- cabelo frontal;
- roupa/armadura;
- arma;
- escudo/offhand;
- acessórios;
- cicatriz/detalhes;
- sombra/FX.

A lista final de layers ainda será congelada na Visual Bible.

## 3. Rig

Direção aprovada:

- rig compartilhado por arquétipo/classe/arma quando possível;
- animações reutilizadas;
- evitar runtime IK complexo;
- permitir, se necessário, bake/cache para spritesheet em mobile depois de validar o rig.

## 4. Golden Rig

Antes de escalar produção:

1. criar 1 Vanguarda canônica;
2. validar idle, ataque, hit, morte e proteção/interceptação;
3. fazer Swap Test com pequenas variações de cabelo, armadura, arma, escudo e peças secundárias;
4. montar 5 Ascendentes visualmente distintos usando o mesmo rig;
5. só depois aumentar o catálogo.

## 5. Identidade em combate vs retrato

Em combate, priorizar:

- silhueta;
- classe/arma;
- cabelo;
- cores;
- acessórios legíveis.

Retrato/card pode carregar:

- rosto;
- cicatrizes;
- detalhes menores;
- identidade individual mais refinada.

Isso permite proceduralidade sem exigir que todo detalhe facial seja legível no sprite de combate.

## 6. Torre e cenários

A Torre não terá um cenário único por andar.

Direção:

- blocos de andares usam biomas/faixas visuais;
- cenários reutilizados dentro da faixa;
- variações cosméticas podem ser geradas pela seed;
- número e temas dos biomas ficam para a Visual Bible.

## 7. Ainda pendente

Não inventar antes da Visual Bible:

- paleta final;
- UI kit;
- tipografia;
- layout da Base;
- layout final da arena;
- coordenadas visuais dos 7 anchors;
- lista final de peças;
- bones/anchors técnicos do rig;
- spritesheets finais;
- VFX;
- identidade visual dos 6 inimigos;
- aparência final do Guardião do Limiar;
- biomas concretos;
- linguagem visual de Rank/Potencial/Stress/Cansaço.
