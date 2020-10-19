#!/bin/bash
cd /etc/consul.d/
sudo cp consul.hcl /home/backupconsul.hcl
sudo sed -e 's/#bootstrap_expect=3/bootstrap_expect=1/g' -e '3 a bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' consul.hcl > consull.hcl && mv consull.hcl consul.hcl -f
sudo sed -i 's/^#server = true/server = true/g' /etc/consul.d/consul.hcl
sudo sed -i '/10.0.4.67/c\retry_join=[\"192.168.1.4\"]' /etc/consul.d/consul.hcl
sudo sed -i '/bind_addr/c\bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' /etc/nomad.d/nomad.hcl

#-e 's/#server/server/g'

#bind_addr = "{{ GetInterfaceIP \"eth1\" }}"
