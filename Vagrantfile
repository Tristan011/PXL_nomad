# -*- mode: ruby -*-
# vi: set ft=ruby :
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  ## voor windows persmissies te omzeilen
  config.ssh.insert_key = false
  config.ssh.private_key_path = "~/.vagrant.d/insecure_private_key"
  ## 
  config.vbguest.auto_update = false
  config.vm.box = "centos/7"

  config.vm.define :server do |server|
    server.vm.hostname = "server"
    server.vm.network "private_network", ip: "192.168.1.4", virtualbox_intnet:"mynetwork"
    server.vm.network "forwarded_port", guest: 8500, host: 8500 
    server.vm.network "forwarded_port", guest: 4646, host: 4646
    server.vm.network "forwarded_port", guest: 9090, host: 9090

    server.vm.provision "ansible" do |ansible|
      ansible.config_file = "ansible/ansible.cfg"
      ansible.playbook = "ansible/plays/servers.yml"
      ansible.groups = {
        "servers" => ["server"],
        "servers:vars" => {"consul_client" => "no", "consul_server"=> "yes", "nomad_master" => "yes", "nomad_server" => "yes"}
      }
      ansible.host_vars = {
#        "server" => {"crond__content" => "server_value"}
      }
#      ansible.verbose = '-vvv'
    end

 end
    (1..2).each do |i|
        config.vm.define "client#{i}" do |client|
			    client.vm.hostname = "client#{i}"
			    client.vm.network "private_network", ip: "192.168.1.#{i+4}", virtualbox_intnet:"mynetwork"
			    client.vm.provision "ansible" do |ansible|
          ansible.config_file = "ansible/ansible.cfg"
          ansible.playbook = "ansible/plays/clients.yml"	
          ansible.groups = {
            "clients" => ["client#{i}"],	
            "clients:vars" => {"consul_client" => "yes", "consul_server"=> "no", "nomad_master" => "no", "nomad_server" => "no"}
          }
          client.vm.provider "virtualbox" do |pmv|
            pmv.memory = 2096
            pmv.cpus = 2
          end
			  end
    end
  end
end
