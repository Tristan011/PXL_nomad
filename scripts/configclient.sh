#!/bin/bash
cd /etc/consul.d/
sudo sed -e '3 a bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' consul.hcl > consull.hcl && mv consull.hcl consul.hcl -f
sudo sed -i '/10.0.4.67/c\retry_join=[\"192.168.1.4\"]' /etc/consul.d/consul.hcl
sudo sed -i '/bind_addr/c\bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' /etc/nomad.d/nomad.hcl
#sudo sed -i '7s/true/false/' /etc/nomad.d/nomad.hcl
#sudo sed -i '/bind_addr/c\bind_addr = "192.168.1.5"' /etc/nomad.d/nomad.hclsed -i '7s/true/false/' nomad.hcl

sudo systemctl enable nomad consul
sudo systemctl restart consul
sudo systemctl start nomad consul
