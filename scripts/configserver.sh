#!/bin/bash
cd /etc/consul.d/
sudo cp consul.hcl /home/backupconsul.hcl
sudo sed -e 's/#bootstrap_expect=3/bootstrap_expect=1/g' -e '3 a bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' consul.hcl > consull.hcl && mv consull.hcl consul.hcl -f
sudo sed -i 's/^#server = true/server = true/g' /etc/consul.d/consul.hcl
sudo sed -i '/10.0.4.67/c\retry_join=[\"192.168.1.4\"]' /etc/consul.d/consul.hcl

#NOMAD
sudo sed -i '/bind_addr/c\bind_addr = "{{ GetInterfaceIP \\"eth1\\" }}"' /etc/nomad.d/nomad.hcl
#sudo sed -i '/client {/a\ \ network_interface = "eth1"' /etc/nomad.d/nomad.hcl
#if [ ! -f /etc/profile.d/nomad.sh ];
#then
#	echo 'export NOMAD_ADDR=http://10.0.0.10:4646' > /etc/nomad.d/nomad.sh
#fi

#sudo sed -i '12s/true/false/' /etc/nomad.d/nomad.hcl
#if ! grep -q 'bind_addr' /etc/consul.d

sudo systemctl enable nomad consul
sudo systemctl restart nomad consul
sudo systemctl start nomad consul


#-e 's/#server/server/g'

#bind_addr = "{{ GetInterfaceIP \"eth1\" }}"
