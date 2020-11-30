# Nomad consul cluster met Ansible

Het doel van deze opdracht is om een productie waardige nomad cluster met consul als service directory op te zetten met behulp van de vagrant shell provisioner en Ansible.
In deze vagrantfile zullen drie virtuele machines aangemaakt worden met twee nomad clients en één nomad server. Op elke node zal consul geïnstalleerd worden waar nomad automatisch mee zal communiceren. 

Als virtuele machine image zal Centos 7 gebruikt worden.
Op elke machine zal  
	* [Docker] (https://docs.docker.com/engine/install/centos/)  
	* [Nomad] (https://www.nomadproject.io/docs/install)  
	* [Consul] (https://learn.hashicorp.com/tutorials/consul/get-started-install)  
geïnstalleerd worden met behulp van Ansible.

Provisioner zal Ansible runnen en naar de playbook gaan van 'server' of 'cient' afhangend van welke soort virtuele machine aangemaakt gaat worden.
De playbook geeft aan welke rollen er zullen uitgevoerd worden. Deze rollen staan in de folder van 'roles/software' en wordt weer onderverdeeld in 'client' en 'server'.

Om de cluster op te stellen moet gebruikt gemaakt worden van de commando:

```bash
    $ vagrant up
    OF
    $ vagrant up --provision
```

Vagrant up doet de provision als het voor de eerste keer wordt uitgevoerd. Wanneer de installatie opnieuw gedaan moet worden moet --provision toegevoegd worden.

In de vagrantfile zal de server "server" genoemt worden. 
De clients zullen "client1" en "client2" genoemt worden en met behulp van een loop gemaakt worden. 
Dus met het volgende commando's kan men op de server of clients:

```bash
    $ vagrant ssh {$name}
```

Om naar de consul web ui te surfen moet naar [localhost] (http://localhost:80) gesurft worden. 
Om naar de nomad web ui te surfen moet naar [localhost:4646] (http://localhost:4646) gesurft worden. 
Manueel kan via port forwarding kan het volgende commando uitgevoerd worden:

```bash
	$ vagrant ssh server -- -L 8500:localhost:8500

    $ vagrant ssh server -- -L 4646:localhost:4646
```
Vervolgens in een browser [localhost:8500] (http://localhost:8500) intypen.
Vervolgens in een browser [localhost:46465] (http://localhost:4646) intypen.

Bronnen
https://docs.docker.com/engine/install/centos/  
https://www.nomadproject.io/docs/install  
https://learn.hashicorp.com/tutorials/consul/get-started-install  
https://www.vagrantup.com/docs/vagrantfile/tips   
https://www.consul.io/docs/agent/options.html#_bind  

https://www.vagrantup.com/docs/networking/forwarded_ports
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/service_module.html
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/lineinfile_module.html
https://stackoverflow.com/questions/57503456/replace-specific-string-in-yaml-file-using-ansible
https://serverfault.com/questions/966428/ansible-replace-regex-replace-span-multiple-lines
https://www.mydailytutorials.com/ansible-replace-example/


