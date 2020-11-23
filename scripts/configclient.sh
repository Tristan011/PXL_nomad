#!/bin/bash
# Consul
cd /etc/consul.d/
sudo sed -e '3 a bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' consul.hcl > consull.hcl && mv consull.hcl consul.hcl -f
sudo sed -i '/10.0.4.67/c\retry_join=[\"192.168.1.4\"]' /etc/consul.d/consul.hcl

## Nomad
sudo sed -i '/bind_addr/c\bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' /etc/nomad.d/nomad.hcl
sudo sed -i '/client {/a\ \ network_interface = "eth1"' /etc/nomad.d/nomad.hcl
sudo sed -i '/servers/c\  servers = ["192.168.1.4:4646"]' /etc/nomad.d/nomad.hcl
#sed -i '7s/true/false/' nomad.hcl

sudo systemctl enable nomad consul
sudo systemctl restart nomad consul
sudo systemctl start nomad consul
