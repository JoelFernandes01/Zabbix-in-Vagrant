#!/bin/bash
ZABBIX_SRV="zabbix-server.connect.local"
ZABBIX_AGE="zabbix-agent"
ZABBIX_HOST=zabbix-proxy
ZABBIX_PRX="zabbix-proxy.connect.local"
echo '192.168.1.50 zabbix-server.connect.local' >> /etc/hosts
echo '192.168.1.60 zabbix-proxy.connect.local' >> /etc/hosts
echo '192.168.1.70 agent.connect.local' >> /etc/hosts
echo "Atualizar pacotes"
sudo timedatectl set-timezone America/Sao_Paulo
sudo apt-get update -y && sudo apt-get upgrade -y
echo "Baixar o repositório do Zabbix"
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu22.04_all.deb
echo "Instalar o repositório"
sudo dpkg -i zabbix-release_latest_7.0+ubuntu22.04_all.deb
echo "Atualizar a lista de pacotes"
sudo apt-get update
echo "Instalar o Zabbix Proxy"
sudo apt install zabbix-proxy-sqlite3 zabbix-agent2 -y
echo "Configurar o Zabbix Proxy"
sudo mkdir /var/lib/zabbix
sudo chown zabbix. -R /var/lib/zabbix
sudo sed -i "s/Hostname=Zabbix proxy/Hostname=$ZABBIX_HOST/" /etc/zabbix/zabbix_proxy.conf
sudo sed -i "s/Server=127.0.0.1/Server=$ZABBIX_SRV/" /etc/zabbix/zabbix_proxy.conf
sudo sed -i "s|^DBName=zabbix_proxy$|DBName=/var/lib/zabbix/zabbix.db|" /etc/zabbix/zabbix_proxy.conf
sudo sed -i "s|^# ProxyOfflineBuffer=1|ProxyOfflineBuffer=24|" /etc/zabbix/zabbix_proxy.conf
sudo sed -i "s/Hostname=Zabbix server/Hostname=$ZABBIX_HOST/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s|^# ProxyConfigFrequency=10|ProxyConfigFrequency=300|" /etc/zabbix/zabbix_proxy.conf
sudo sed -i "s/#\s*Timeout=3/Timeout=30/" /etc/zabbix/zabbix_agent2.conf
echo "Reiniciar e habilitar serviços"
sudo systemctl start zabbix-proxy zabbix-agent2
sudo systemctl enable zabbix-proxy zabbix-agent2
#######################################  FIM DA INSTALAÇÃO ###############################################################################