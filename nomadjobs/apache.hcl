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