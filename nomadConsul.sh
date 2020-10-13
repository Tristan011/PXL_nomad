#!/bin/bash
# Download Nomad & Consul
# https://www.nomadproject.io/docs/install
echo Installing Nomad...
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install nomad -y
sudo yum -y install consul -y