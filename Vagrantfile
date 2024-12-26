# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Configuração do Zabbix Server
  config.vm.define "srv" do |srv|
    srv.vm.box = "ubuntu/jammy64"
    srv.vm.box_version = "20241002.0.0"
    srv.vm.hostname = "zabbix-server.connect.local"
    srv.vm.network "public_network", ip: "192.168.1.50"
    srv.vm.provision "shell", path: "script-zabbix-server.sh"
    srv.vm.provision "shell", path: "script-agent.sh"
    srv.vm.provision "shell", path: "script-grafana.sh"
    srv.vm.synced_folder "./web", "/etc/zabbix/web"
    srv.vm.provider "virtualbox" do |v|
      v.name = "zabbix-server"
      v.memory = 2048
      v.cpus = 2
    end
  end

  # Configuração do Zabbix Proxy
  config.vm.define "prx" do |prx|
    prx.vm.box = "ubuntu/jammy64"
    prx.vm.box_version = "20241002.0.0"
    prx.vm.hostname = "zabbix-proxy.connect.local"
    prx.vm.network "public_network", ip: "192.168.1.60"
    prx.vm.provision "shell", path: "script-zabbix-proxy.sh"
    prx.vm.provision "shell", path: "script-agent.sh"
    prx.vm.provider "virtualbox" do |v|
      v.name = "zabbix-proxy"
      v.memory = 1024
      v.cpus = 1
    end
  end

  # Configuração do Zabbix Agent
  config.vm.define "agt" do |agt|
    agt.vm.box = "ubuntu/jammy64"
    agt.vm.box_version = "20241002.0.0"
    agt.vm.hostname = "zabbix-agent.connect.local"
    agt.vm.network "public_network", ip: "192.168.1.70"
    agt.vm.provision "shell", path: "script-agent.sh"
    agt.vm.provider "virtualbox" do |v|
      v.name = "zabbix-agent"
      v.memory = 1024
      v.cpus = 1
    end
  end
end
