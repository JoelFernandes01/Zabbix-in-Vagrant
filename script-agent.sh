#!/bin/bash
ZABBIX_SRV="zabbix-server.connect.local"
ZABBIX_AGE="zabbix-agent"
ZABBIX_HOST=zabbix-server
echo '192.168.1.50 zabbix-server.connect.local' >> /etc/hosts
echo '192.168.1.60 zabbix-proxy.connect.local' >> /etc/hosts
echo '192.168.1.70 agent.connect.local' >> /etc/hosts
sudo timedatectl set-timezone America/Sao_Paulo
sudo apt-get update -y && sudo apt-get upgrade -y
sudo wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu22.04_all.deb
sudo dpkg -i zabbix-release_latest_7.0+ubuntu22.04_all.deb
sudo apt-get update
sudo apt install zabbix-agent2 -y
sudo sed -i "s/#\Hostname=Zabbix server/Hostname=$ZABBIX_HOST/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/Server=127.0.0.1/Server=$ZABBIX_SRV/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/ServerActive=127.0.0.1/ServerActive=$ZABBIX_SRV/" /etc/zabbix/zabbix_agent2.conf
sudo sed -i "s/#\s*Timeout=3/Timeout=30/" /etc/zabbix/zabbix_agent2.conf
sudo systemctl start zabbix-agent2
sudo systemctl enable zabbix-agent2