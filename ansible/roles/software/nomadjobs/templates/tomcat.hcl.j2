job "tomcat" {
    datacenters = ["dc1"]

    update {
        stagger = "30s"
        max_parallel = 1
    }

    group "dev" {
        count = 5
        task "tomcat" {
            driver = "docker"
            config {
                image = "tomcat:8.0"
                port_map = {
                  http = 8080

                }
            }
            service {
                port = "http"
                check {
                    type = "tcp"

                    interval = "10s"
                    timeout = "2s"
                }
            }
            resources {
                cpu = 500
                memory = 256
                network {
                    mbits = 100
                    port "http" {
                    }
                }
            }
        }
    }
}