Este projeto configura um Raspberry Pi como um servidor de filtragem de conteúdo para fornecer um ambiente de internet mais seguro para crianças. Ele utiliza Pi-hole, OpenDNS FamilyShield, Squid e DansGuardian para bloquear anúncios, rastreadores e conteúdo inadequado.

Visão Geral do Script
O script realiza as seguintes ações:

Atualiza o sistema.
Instala e configura o Pi-hole.
Configura o Pi-hole para usar os servidores DNS do OpenDNS FamilyShield.
Instala e configura o DansGuardian.
Instala e configura o Squid como um proxy transparente.
Configura regras de redirecionamento no IPTables para filtrar tráfego HTTP e HTTPS.
Reinicia os serviços para aplicar as configurações.

Após a execução deste script, o Raspberry Pi atuará como um servidor de filtragem de conteúdo, bloqueando anúncios, rastreadores e conteúdo inadequado, criando um ambiente de navegação mais seguro para crianças.

Se você encontrar qualquer problema ou tiver sugestões de melhorias, sinta-se à vontade para contribuir enviando issues ou pull requests no repositório do projeto.
