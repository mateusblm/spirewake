Arquivos exatamente como entregues no pacote P2.4B (sha256 idêntico ao zip).
Os dois `forearm_hand_*_front3q.png` têm assinatura JPEG (ffd8ffe0 / JFIF), não PNG, e portanto
não possuem canal alpha. O Godot recusa importá-los com extensão .png, por isso esta pasta tem
`.gdignore` e o Lab carrega cópias byte-idênticas renomeadas para `.jpg` no diretório pai.
Isso NÃO é uma edição de arte: os bytes são os mesmos. O asset continua reprovado por GR012.
