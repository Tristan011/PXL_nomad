Vagrant.configure("2") do |config|
  #config.vm.provision "shell", inline: "echo Hello"

  config.vm.box = "centos/7"
  
  config.vm.define "web" do |web|
    web.vm.hostname = "webserver"
	web.vm.network "private_network", ip: "192.168.1.4", virtualbox_intnet:"mynetwork"
	web.vm.provision "shell" do |s|
		#s.inline = "mkdir /tmp/consul"
		s.inline = "sudo nomad agent -server -bind=192.168.1.4&"
		s.inline = "sudo consul agent -server -bootstrap-expect=1 -node=agent-server -bind=192.168.1.4 -data-dir=/tmp/consul -config-dir=/etc/consul.d&"
		s.inline = "sudo consul join 192.168.1.5 192.168.1.6"
	end	
  end
  
	(1..2).each do |i|
		config.vm.define "client#{i}" do |client|
			client.vm.hostname = "client#{i}"
			client.vm.network "private_network", ip: "192.168.1.#{i+4}", virtualbox_intnet:"mynetwork"
			client.vm.provision "shell" do |sc|
				sc.inline = "sudo nomad agent -client -bind=192.168.1.#{i+4}&"
				sc.inline = "sudo consul agent -node=agent-#{i} -bind=192.168.1.#{i+4} -enable-script-checks=true -data-dir=/tmp/consul -config-dir=/etc/consul.d&"
			end
	end
	config.vm.provision "shell", path: "nomadConsul.sh"
	config.vm.provision "shell", path: "docker.sh"
end


# https://www.vagrantup.com/docs/vagrantfile/tips