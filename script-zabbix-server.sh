#!/bin/bash
# Variáveis
MYSQL_ROOT_PASSWORD="mysqlpwd"
ZABBIX_DB="zabbix"
ZABBIX_USER="zabbix"
ZABBIX_PASSWORD="zabbix"
echo '192.168.1.50 zabbix-server.connect.local' >> /etc/hosts
echo '192.168.1.51 proxy-server.connect.local' >> /etc/hosts
echo '192.168.1.52 agent.connect.local' >> /etc/hosts
echo "Atualizar pacotes"
sudo timedatectl set-timezone America/Sao_Paulo
sudo apt-get update -y && sudo apt-get upgrade -y
echo "Instalar o MySQL"
sudo apt-get install -y mysql-server
echo "Iniciar e habilitar o MySQL"
sudo systemctl start mysql
sudo systemctl enable mysqlsudo mysql -uroot <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PASSWORD';
EOF
sudo mysql -uroot -p$MYSQL_ROOT_PASSWORD <<EOF
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF
mysql -uroot -p$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE $ZABBIX_DB character set utf8mb4 collate utf8mb4_bin;
CREATE USER '$ZABBIX_USER'@'localhost' IDENTIFIED BY '$ZABBIX_PASSWORD';
GRANT ALL PRIVILEGES ON $ZABBIX_DB.* TO '$ZABBIX_USER'@'localhost';
SET GLOBAL log_bin_trust_function_creators = 1;
EOF
echo "Baixar o repositório do Zabbix"
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu22.04_all.deb
echo "Instalar o repositório"
sudo dpkg -i zabbix-release_latest_7.0+ubuntu22.04_all.deb
echo "Atualizar a lista de pacotes"
sudo apt-get update
echo "Instalar o Zabbix server, frontend, e agent2"
sudo apt install zabbix-server-mysql zabbix-frontend-php zabbix-nginx-conf zabbix-sql-scripts zabbix-agent2 -y
echo "Importar o esquema inicial do Zabbix"
sudo zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u$ZABBIX_USER -p$ZABBIX_PASSWORD $ZABBIX_DB
sudo mysql -e "SET GLOBAL log_bin_trust_function_creators = 1;"
echo "Configurar o Zabbix Server"
sudo sed -i "s/# DBPassword=/DBPassword=$ZABBIX_PASSWORD/" /etc/zabbix/zabbix_server.conf
echo "Configurar o Zabbix Frontend"
sudo sed -i 's/#\s*listen\s*8080;/        listen          80;/' /etc/zabbix/nginx.conf
sudo sed -i 's/#\s*server_name\s*example.com;/        server_name     192.168.1.50;/' /etc/zabbix/nginx.conf
echo "Reiniciar e habilitar serviços"
systemctl restart zabbix-server zabbix-agent2 nginx php8.1-fpm
systemctl enable zabbix-server zabbix-agent2 nginx php8.1-fpm
#######################################  FIM DA INSTALAÇÃO ###############################################################################