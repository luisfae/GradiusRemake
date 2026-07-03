Versão 03/07

OBS.: Dei um merge que parece q não foi 100%, tinha coisa que eu tinha mudado no meu que tava não mudado no que ficou merged.
Na duvida usar o do branch Nconseguicommitarnooutropelogitgui

Adicionado:
- Inimigo turret que não anda e dispara projeteis
- Projetil inimigo

Versão 01/07

Mudanças:
- Mudei a vida do personagem do GlobalVars para o player, considerei a ideia de deixar no global, porém imaginei funções que chamariam funções e tal,
ai como fui criado na orientação a objetos queria manter as coisas mais encapsuladas e diretas, qualquer coisa me responsabilizo por trocar pro GlobalVars de volta.
- Mudei o tiro checar se colidiu com o inimigo, agora o inimigo quem checa se alguem do grupo Player projectiles entrou na sua area2d

Adicionado:
- Upgrade Shield funcional
- Cena chamada EnemySpawner, ela é uma area2d que quando em contato com a area2d adicionada a camera, spawna o inimigo nela configurado em sua posição
@ Considerar se não é mais facil apenas deixar o inimigo inerte até entrar na posição correta, não sei ainda, mas um spawner soa bem
- Cena chamada Group, pode ser colocado inimigos como filho dessa cena, e quando restar apenas 1 deles vivo, o Group tem um scrip que ativa uma bool no inimigo que faz ele spawnar um Upgrade em sua posição ao morrer.
@ Considerei criar esses grupos através do spawner, ou ja deixar eles setados na cena desativados, vamos ver o que fazer quanto a isso

Coisas que pretendo fazer:
- Terminar o missile, falta fazer o raycast dele pra ele andar sob o terreno
- Inimigos, pretendo fazer os estaticos que apenas lançam bullets no jogador
- Estou estudando pra fazer o que sobe e desce e o Fan
