Vagrant.configure("2") do |config|
  #config.vm.provision "shell", inline: "echo Hello"

  config.vm.box = "centos/7"
  config.vm.define "web" do |web|
    web.vm.hostname = "webserver"
	web.vm.network "private_network", ip: "192.168.1.4", virtualbox_intnet:"mynetwork"
	#web.vm.provision "shell", inline: "consul agent -bind '{{ GetPrivateInterfaces | include "mynetwork" "192.168.1.4/24" | attr "address" }}'"	
	web.vm.provision "shell", inline: "nomad agent -dev -bind=192.168.1.4"
	web.vm.provision "shell", inline: "consul agent -bind '{{ GetInterfaceIP "192.168.1.4" }}'"
  end

  config.vm.define "client01" do |client01|
    client01.vm.hostname = "client01"
	client01.vm.network "private_network", ip: "192.168.1.5", virtualbox_intnet:"mynetwork"
	#client01.vm.provision "shell", inline: "consul agent -bind '{{ GetPrivateInterfaces | include "mynetwork" "192.168.1.5/24" | attr "address" }}'"
	client01.vm.provision "shell", inline: "nomad agent -dev -bind=192.168.1.5"
	client01.vm.provision "shell", inline: "consul agent -bind '{{ GetInterfaceIP "192.168.1.5" }}'"
  end
  
   config.vm.define "client02" do |client02|
    client02.vm.hostname = "client02"
	#client02.vm.provision "shell", inline: "consul agent -bind '{{ GetPrivateInterfaces | include "mynetwork" "192.168.1.6/24" | attr "address" }}'"	
	client02.vm.provision "shell", inline: "nomad agent -dev -bind=192.168.1.6"
	client02.vm.provision "shell", inline: "consul agent -bind '{{ GetInterfaceIP "192.168.1.6" }}'"
  end
  
  config.vm.provision "shell", path: "nomadConsul.sh"
  config.vm.provision "shell", path: "docker.sh"
  
end


#nomad/consul bind_addr om service aan de 2de interface te koppelen
# In de .hcl file van vm zelf gaan en veranderen
# https://www.consul.io/docs/agent/options.html
# https://gist.github.com/torian/9aaad52f432ddc325b19cd1db54bdca6
# https://groups.google.com/g/nomad-tool/c/ayexrDb-pmI?pli=1

#https://www.nomadproject.io/docs/commands/agent