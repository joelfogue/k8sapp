#!/bin/bash -eux

# Install Ansible
sudo apt-add-repository ppa:ansible/ansible
sudo apt -y update
sudo apt -y install ansible