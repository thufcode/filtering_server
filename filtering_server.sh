#!/bin/bash

# Atualiza o sistema
echo "Atualizando o sistema..."
sudo apt-get update && sudo apt-get upgrade -y

# Instalação do Pi-hole
echo "Instalando o Pi-hole..."
curl -sSL https://install.pi-hole.net | bash

# Configura o Pi-hole para usar OpenDNS FamilyShield
echo "Configurando Pi-hole para usar OpenDNS FamilyShield..."
sudo sed -i 's/PIHOLE_DNS_1=.*$/PIHOLE_DNS_1=208.67.222.123/g' /etc/pihole/setupVars.conf
sudo sed -i 's/PIHOLE_DNS_2=.*$/PIHOLE_DNS_2=208.67.220.123/g' /etc/pihole/setupVars.conf
sudo pihole -r -a

# Instalação do DansGuardian
echo "Instalando o DansGuardian..."
sudo apt-get install dansguardian -y

# Instalação do Squid
echo "Instalando o Squid..."
sudo apt-get install squid -y

# Configuração do Squid para trabalhar com DansGuardian
echo "Configurando o Squid para trabalhar com DansGuardian..."
sudo sed -i 's/http_port 3128/http_port 3128 transparent/g' /etc/squid/squid.conf
echo "
http_port 3128

# Squid redirect to DansGuardian
cache_peer 127.0.0.1 parent 8080 0 no-query no-digest

never_direct allow all

# Allow access to local machine
http_access allow localhost

# Default rule - deny all other access
http_access deny all
" | sudo tee /etc/squid/squid.conf

# Configuração do DansGuardian
echo "Configurando o DansGuardian..."
sudo sed -i 's/^UNCONFIGURED - Please remove this line after configuration/ /' /etc/dansguardian/dansguardian.conf
echo "
# Configuration file for DansGuardian

# Network Settings
filterip = 127.0.0.1
filterport = 8080

# Logging Settings
loglevel = 3

# Content Filtering Settings
naughtynesslimit = 50
bannedphrasemode = 3
weightedphrasemode = 2

# URL Banning
bannedurllist = '/etc/dansguardian/lists/bannedurllist'
exceptionurllist = '/etc/dansguardian/lists/exceptionurllist'

# Content Phrase Lists
bannedphraselist = '/etc/dansguardian/lists/bannedphraselist'
exceptionphraselist = '/etc/dansguardian/lists/exceptionphraselist'

# PICS filtering
filterpics = on

# Access Denied Message
accessdeniedaddress = 'http://yourserver.yourdomain/cgi-bin/dansguardian.pl'

# Other Settings
reportinglevel = 2
reportinglevelaccessdenied = 1
maxcontentscansize = 2000
nonstandarddelimiter = on
downloadmanager = off
maxchildren = 200
minchildren = 4
minsparechildren = 4
maxsparechildren = 20
maxagechildren = 500
maxips = 0
proxyip = 127.0.0.1
proxyport = 3128
" | sudo tee /etc/dansguardian/dansguardian.conf

# Reinicia serviços
echo "Reiniciando serviços..."
sudo systemctl restart pihole-FTL
sudo systemctl restart squid
sudo systemctl restart dansguardian

echo "Configuração concluída!"
