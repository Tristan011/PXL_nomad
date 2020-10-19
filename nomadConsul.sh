#!/bin/bash
# Download Nomad & Consul
# https://www.nomadproject.io/docs/install
echo Installing Nomad and consul...
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install nomad -y
sudo yum -y install consul -y
sudo systemctl enable nomad
sudo systemctl start nomad
sudo systemctl enable consul
sudo systemctl start consul

# nano install
sudo yum install nano -y