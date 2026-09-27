# Expedição e Permadeath

**Status:** FROZEN

## 1. Fluxo funcional de uma expedição

1. escolher andar;
2. preparar party e formação;
3. confirmar expedição;
4. gerar/carregar sequência determinística;
5. apresentar próximo encontro;
6. executar combate automático;
7. permitir uso do comando tático único;
8. resolver encontro;
9. abrir intervalo com estado e decisão Continuar/Recuar;
10. repetir até conclusão, recuo ou derrota;
11. retornar obrigatoriamente à Base após encerramento.

## 2. Preparação

Antes de entrar:

- jogador escolhe o próximo andar de progressão ou um já concluído;
- seleciona 1–5 Ascendentes;
- escolhe anchors iniciais;
- vê avisos relevantes de Cansaço/risco;
- formação fica bloqueada para aquele andar após confirmar.

## 3. Geração e determinismo

### Primeiro clear
Usa a sequência curada do documento `TOWER_AND_ENCOUNTERS.md`.

### Revisita
A sequência inteira é gerada pela seed no início e persistida.

A seed cobre pelo menos:

- sequência de templates;
- posição do Elite;
- modificador Elite;
- anchors/formação inimiga.

Reload não rerrola a expedição.

## 4. Prévia de encontro

Antes de cada combate, o jogador recebe informação suficiente para tomar decisão consciente.

Pode incluir:

- Normal/Elite/Boss;
- quantidade de inimigos;
- papéis/composição;
- modificador Elite quando houver.

Não é necessário revelar atributos numéricos completos dos inimigos.

Antes do Boss, deve existir aviso explícito de que não haverá recuo após o início.

## 5. Combate e comando

O combate é automático.

A única intervenção direta é 1 comando tático por andar. Abrir a seleção pode pausar brevemente a luta. Depois de usado, o efeito dura 8 s e a carga é consumida.

A carga é recriada apenas em uma nova expedição/andar.

## 6. Resolução de encontro

### Vitória

Condição:

- todos os inimigos mortos;
- pelo menos 1 Ascendente vivo.

Sobreviventes:

- recebem XP;
- recebem recuperação de Stress do tipo de encontro;
- mantêm HP atual;
- mantêm Stress restante;
- recebem Cansaço.

Mortos:

- não recebem XP daquele encontro;
- não recebem Cansaço daquele encontro;
- saem do roster jogável;
- entram no registro histórico de mortos.

Se a party começou com 5 e 2 morreram, o próximo encontro começa com 3. Não há reposição no meio do andar.

### Derrota

Condição:

- 0 Ascendentes vivos.

Se último inimigo e último Ascendente morrem na mesma resolução, é derrota.

O encontro que terminou em derrota:

- não concede XP;
- não concede recompensa daquele Elite/Boss;
- não concede conclusão de andar.

Tudo obtido nos encontros anteriores permanece.

## 7. Recuo

Recuo só pode acontecer entre encontros.

Ao recuar:

- mortos continuam mortos;
- sobreviventes retornam;
- XP já recebido permanece;
- bônus de Elite já recebido permanece;
- não recebe os +40 de conclusão do andar;
- Stress zera ao chegar à Base;
- Cansaço permanece;
- HP é restaurado na Base na V1.

Depois que o Boss começou, não há recuo.

## 8. Morte

Regra central:

> **HP 0 = morte imediata e irreversível.**

Não existe:

- estado recuperável de “caído”;
- rolagem de sobrevivência pós-luta;
- ressurreição na V1.

O corpo permanece caído visualmente até o fim do encontro, mas isso é apresentação.

Ao morrer:

- sai da Utility AI;
- deixa de ser alvo válido para cura/buffs;
- cancela ação em curso;
- libera seu anchor para futuras regras de reposicionamento;
- dispara evento de morte de aliado nos sobreviventes.

Stress e Cansaço nunca matam diretamente.

## 9. Registro histórico do morto

A entidade jogável sai do roster, mas sua identidade não é apagada.

Preservar pelo menos:

- UUID;
- seed;
- nome;
- aparência/DNA visual;
- classe e especialização;
- Rank;
- Potencial;
- nível e XP final;
- atributos finais;
- personalidade;
- Traits;
- evoluções escolhidas;
- andar máximo em que participou;
- data/ciclo da morte;
- andar e encontro da morte;
- causa/atacante quando aplicável.

Objetivo: suportar futuro Hall dos Caídos sem reconstruir dados perdidos.

Não é necessário armazenar telemetria histórica enorme na V1.

## 10. Liberação de slot

Morte confirmada remove o Ascendente do roster jogável e libera imediatamente sua vaga do limite de 15.

## 11. Proteção de wipe/roster zero

A party pode ter 1–5 membros, portanto ficar com menos de 5 não gera personagem gratuito.

A proteção de geração só ocorre quando **não resta nenhum Ascendente jogável/vivo no roster**.

Nesse caso, o jogo gera o necessário para restaurar um mínimo de 5, o que em roster zero significa 5 novos Ascendentes.

Regras:

- mortes permanecem;
- progresso máximo da Torre não é apagado;
- recompensas já garantidas permanecem;
- não deve existir uso lucrativo dessa proteção como farm.

## 12. Filosofia de punição

Não adicionar custo econômico extra à morte.

Não perder por causa dela:

- recurso de summon já obtido;
- XP de outros personagens;
- Rank;
- progresso máximo da Torre;
- moeda adicional.

> **A morte custa uma pessoa, não uma pilha de sistemas.**

## 13. Autosave e checkpoints

Criar checkpoint persistente no mínimo:

- ao iniciar uma expedição gerada;
- ao final de cada encontro;
- ao recuar;
- ao concluir/perder o andar;
- após summon;
- após Convergência confirmada e antes da revelação;
- após evolução/Despertar/especialização.

Checkpoint de encontro deve persistir:

- resultado;
- mortos;
- HP dos sobreviventes;
- Stress;
- Cansaço adquirido;
- XP;
- recompensas;
- estado do andar;
- carga do comando;
- seed/estado RNG necessário.

Fechar o jogo após uma morte não desfaz a morte.

## 14. Retorno obrigatório

Ao concluir o andar, o jogador não encadeia diretamente o próximo. Sempre retorna à Base para:

- restaurar HP;
- zerar Stress;
- aplicar/visualizar Cansaço;
- recuperar quem ficou na Base;
- resolver evoluções pendentes;
- ajustar roster/formação;
- invocar/convergir se desejar;
- escolher nova subida.
