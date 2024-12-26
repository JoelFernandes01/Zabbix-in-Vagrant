
### Descrição do Laboratório

Neste laboratório, o objetivo foi criar um ambiente de testes com 3 máquinas utilizando o *Vagrant*.</br>
Os arquivos irão criar um Zabbix Server 7.0, já com o Grafana, um Zabbix Proxy 7.0 e um Ubuntu Server 22.04 como Zabbix Agent:

- *Nome da Máquina*: zabbix-server
- *Memória*: 2048
- *CPU**: 2 CPUs
- *ShellScript* : script-zabbix-server.sh

- *Nome da Máquina*: zabbix-proxy
- *Memória*: 1024
- *CPU*: 1 CPUs
- *ShellScript* : script-zabbix-proxy.sh

- *Nome da Máquina*: zabbix-agent
- *Memória*: 1024
- *CPU*: 1 CPUs
- *ShellScript* : script-agent.sh

