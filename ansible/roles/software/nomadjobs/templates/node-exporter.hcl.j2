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