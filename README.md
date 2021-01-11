# Nomad consul cluster monitoring met prometheus

<h2> Vagrant </h2>
Om de cluster op te stellen met vagrant moet gebruikt gemaakt worden van de commando:

```bash
    $ vagrant up
    OF
    $ vagrant up --provision
```


In de vagrantfile zal 1 server met 2 nodes aangemaakt worden. De server wordt "server" genoemt. 
De clients zullen "client1" en "client2" genoemt worden en met behulp van een loop aangemaakt worden.
Met Ansible wordt de software op de vm's geïnstalleerd.

```bash
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
```

Met het volgende commando's kan men op de server of clients:

```bash
    $ vagrant ssh {$name}
```

Om naar de consul web ui te surfen moet naar [localhost:8500] (http://localhost:8500) gesurft worden. 
Om naar de nomad web ui te surfen moet naar [localhost:4646] (http://localhost:4646) gesurft worden. 
In de vagrantfile worden de poorten geforward. Manueel kan via port forwarding het volgende commando uitgevoerd worden:

```bash
	$ vagrant ssh server -- -L 8500:localhost:8500

    $ vagrant ssh server -- -L 4646:localhost:4646
```
<h2>Nomad</h2>

De nomad job "prometheus" wordt gebruikt om een prometheus container te draaien op één van de clients. In de prometheus.hcl worden ook de rules.yml en prometheus.yml meegegeven. prometheus.yml configureert prometheus en rules.yml stelt de alert rules in.

```bash
    job "prometheus" {
  datacenters = ["dc1"]
  type = "service"

  group "prometheus" {
    count = 1
    network {
			port "prometheus_ui" {
			  to = 9090
			   static = 9090
			}
		}
    
    task "prometheus" {
      template {
        change_mode = "noop"
        destination = "local/rules.yml"
        data = <<EOH
---
groups:
- name: prometheus_alerts
  rules:
  - alert: Webserver down
    expr: absent(up{job="webserver"})
    for: 10s
    labels:
      severity: critical
    annotations:
      description: "Our webserver is down."
EOH
      }

      template {
        change_mode = "noop"
        destination = "local/prometheus.yml"
        data = <<EOH
---
global:
  scrape_interval:     5s
  evaluation_interval: 5s

alerting:
  alertmanagers:
  - consul_sd_configs:
    - server: '192.168.1.4:8500'
      services: ['alertmanager']

rule_files:
  - "rules.yml"

scrape_configs:

  - job_name: 'alertmanager'

    consul_sd_configs:
    - server: '192.168.1.4:8500'
      services: ['alertmanager']

  - job_name: 'prometheus'

    consul_sd_configs:
    - server: '192.168.1.4:8500'
      services: ['prometheus']

    relabel_configs:
    - source_labels: [__meta_consul_service]
      target_label: job
    
    scrape_interval: 5s
    metrics_path: /metrics
    params:
      format: ['prometheus']

  - job_name: 'nomad_metrics'

    consul_sd_configs:
    - server: '192.168.1.4:8500'
      services: ['nomad-client', 'nomad']

    relabel_configs:
    - source_labels: ['__meta_consul_tags']
      regex: '(.*)http(.*)'
      action: keep

    scrape_interval: 5s
    metrics_path: /v1/metrics
    params:
      format: ['prometheus']

  - job_name: 'webserver'

    consul_sd_configs:
    - server: '192.168.1.4:8500'
      services: ['webserver']

    metrics_path: /metrics

  - job_name: 'node_exporter'  

    consul_sd_configs:
    - server: '192.168.1.4:8500'
      services: ['node-exporter']

    relabel_configs:
    - source_labels: [__meta_consul_service]
      target_label: job
    
    scrape_interval: 5s
    metrics_path: /metrics
    params:
      format: ['prometheus']
EOH
      }
      driver = "docker"
      config {
        image = "prom/prometheus:latest"
        ports = ["prometheus_ui"]
        logging {
				type = "journald"
				config {
					tag = "PROMETHEUS"
				}
			}
        volumes = [
          "local/rules.yml:/etc/prometheus/rules.yml",
          "local/prometheus.yml:/etc/prometheus/prometheus.yml"
        ]
      }
      service {
        name = "prometheus"
        port = "prometheus_ui"
            tags = [
      	        "metrics"
            ]
      }
      resources {
      	        memory = 100
            }
    }
  }
}
```
De nomad job "grafana" dient om de metrics van Prometheus te visualiseren. Grafana kan via de ui Prometheus als datasource gebruiken.

```bash
job "grafana" {
  datacenters = ["dc1"]
  type = "service"

  group "grafana" {
    count = 1
    network {
      port "grafana_ui" {
        to = 3000
         static = 3000
      }
    }
    task "grafana" {
      driver = "docker"
      config {
        image = "grafana/grafana:latest"
        ports = ["grafana_ui"]
        logging {
          type = "journald"
          config {
            tag = "GRAFANA"
          }
        }
      }
      resources {
        memory = 100
      }
      service {
        name = "grafana"
        
      }
    }
  }
}
```
De nomad job "alermanager" dient om de alert van Prometheus te managen.

```bash
job "alertmanager" {
  datacenters = ["dc1"]
  type = "service"

  group "alerting" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }
    ephemeral_disk {
      size = 200
    }

    task "alertmanager" {
      driver = "docker"
      config {
        image = "prom/alertmanager:latest"
        port_map {
          alertmanager_ui = 9093
        }
      }
      resources {
        network {
          mbits = 10
          port "alertmanager_ui" {}
        }
      }
      service {
        name = "alertmanager"
        tags = ["urlprefix-/alertmanager strip=/alertmanager"]
        port = "alertmanager_ui"
        check {
          name     = "alertmanager_ui port alive"
          type     = "http"
          path     = "/-/healthy"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
```
De nomad job "node-exporter" dient om de metrics van elke node op te halen. Het type van node-exporter is "system" en niet "service" zodat het op elke beschikbare node gezet word.

```bash
job "node-exporter" {
  datacenters = ["dc1"]
  type = "system"

  group "node-exporter" {
    count = 1
    network {
  		    port "node_exporter_port" {
    	        to = 9100
      	        static = 9100
			    }
		}

    task "node-exporter" {
      driver = "docker"
      config {
        image = "prom/node-exporter:latest" #"prom/node-exporter:v0.17.0"
        force_pull = true
        logging {
          type = "journald"
          config {
            tag = "NODE-EXPORTER"
          }
        }
        ports = ["node_exporter_port"]

      }

      service {
        name = "node-exporter"
        tags = [
          "metrics", "node-exporter"
        ]
        port = "node_exporter_port"
      }

      resources {
        memory = 100
      }
    }
  }
}
```
De nomad job "webserver" dient om een simpel webserver op te stellen om de alerts te testen.

```bash
job "webserver" {
  datacenters = ["dc1"]
  type = "service"

  group "webserver" {
    count = 1
    network {
      port "webserver_ui" {
        to = 80
         static = 80
      }
    }
    task "webserver" {
      driver = "docker"
      config {
        image = "httpd:latest"
        ports = ["webserver_ui"]
        logging {
          type = "journald"
          config {
            tag = "webserver"
          }
        }
      }
      resources {
        memory = 100
      }
      service {
        name = "webserver"
        
      }
    }
  }
}
```
<h2> Verdeling van de taken <h2>

Alles samen gemaakt.

<h2> Bronnen <h2>
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
https://github.com/geerlingguy/ansible-role-docker/tree/master/tasks
https://www.vagrantup.com/docs/networking/basic_usage
https://www.nomadproject.io/docs/schedulers
https://learn.hashicorp.com/tutorials/nomad/prometheus-metrics



