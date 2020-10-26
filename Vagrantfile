Vagrant.configure("2") do |config|
 
  config.vm.box = "centos/7"
  
  config.vm.define "web" do |web|
    web.vm.hostname = "webserver"
	web.vm.network "private_network", ip: "192.168.1.4", virtualbox_intnet:"mynetwork"
	web.vm.provision "shell", path: "scripts/configserver.sh"
  end
  
	(1..2).each do |i|
		config.vm.define "client#{i}" do |client|
			client.vm.hostname = "client#{i}"
			client.vm.network "private_network", ip: "192.168.1.#{i+4}", virtualbox_intnet:"mynetwork"
			client.vm.provision "shell", path: "scripts/configclient.sh"		
			end
	end
	#config.vm.provision "shell", path: "scripts/update.sh"
	config.vm.provision "shell", path: "scripts/nomadConsul.sh"
	config.vm.provision "shell", path: "scripts/docker.sh"
end
# https://www.vagrantup.com/docs/vagrantfile/tips