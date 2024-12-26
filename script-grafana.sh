#!/bin/bash
sudo wget -q -O - https://packages.grafana.com/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/grafana.gpg > /dev/null
sudo echo "deb [signed-by=/usr/share/keyrings/grafana.gpg] https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo sudo apt update
sudo apt install grafana -y
sudo systemctl enable --now grafana-server
grafana-cli plugins install alexanderzobnin-zabbix-app
systemctl restart grafana-server