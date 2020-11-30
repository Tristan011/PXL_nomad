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

  config.vm.define :server do |server|4
    server.vm.hostname = "server"
    server.vm.network "private_network", ip: "192.168.1.4", virtualbox_intnet:"mynetwork"
    server.vm.network "forwarded_port", guest: 8500, host: 80 # https://www.vagrantup.com/docs/networking/basic_usage
    server.vm.network "forwarded_port", guest: 4646, host: 4646

    server.vm.provision "ansible" do |ansible|
      ansible.config_file = "ansible/ansible.cfg"
      ansible.playbook = "ansible/plays/server.yml"
      ansible.groups = {
        "servers" => ["server"],
#        "servers:vars" => {"crond__content" => "servers_value"}
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
          ansible.playbook = "ansible/plays/client.yml"	
          ansible.groups = {
            "clients" => ["client#{i}"], }	
			  end
    end
  end
end
