# Nomad consul cluster

Het doel van deze opdracht is om een productie waardige nomad cluster met consul als service directory op te zetten met behulp van de vagrant shell provisioner.
In deze vagrantfile zullen drie virtuele machines aangemaakt worden met twee nomad clients en één nomad server. Op elke node zal consul geïnstalleerd worden waar nomad automatisch mee zal communiceren. 

Als virtuele machine image zal Centos 7 gebruikt worden.
Op elke machine zal 
	* [Docker] (https://docs.docker.com/engine/install/centos/) 
	* [Nomad] (https://www.nomadproject.io/docs/install)
	* [Consul] (https://learn.hashicorp.com/tutorials/consul/get-started-install)
geïnstalleerd worden met behulp van de HashiCorp yum repositories. 
Docker installatie wordt via de docker.sh script file geïnstalleerd op de nodes.
Nomad en Consul worden via nomadConsul.sh script file geïnstalleerd op de nodes.

Om de cluster op te stellen moet gebruikt gemaakt worden van de commando:

```bash
    $ vagrant up
    OF
    $ vagrant up --provision
```

Vagrant up doet de provision als het voor de eerste keer wordt uitgevoerd. Wanneer de installatie opnieuw gedaan moet worden moet --provision toegevoegd worden.

In de vagrantfile zal de server "web" genoemt worden. 
De clients zullen "client1" en "client2" genoemt worden en met behulp van een loop gemaakt worden. 
Dus met het volgende commando's kan men op de server of clients:

```bash
    $ vagrant ssh {$name}
```

Om naar de consul web ui te surfen moet het volgende commando uitgevoerd worden:

```bash
	$ vagrant ssh web -- -L 8500:localhost:8500
```
Vervolgens in een browser [localhost:8500] (http://localhost:8500) intypen.

Bronnen
https://docs.docker.com/engine/install/centos/
https://www.nomadproject.io/docs/install
https://learn.hashicorp.com/tutorials/consul/get-started-install
https://www.vagrantup.com/docs/vagrantfile/tips
https://www.consul.io/docs/agent/options.html#_bind

