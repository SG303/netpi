#!/bin/bash

# Check if ansible is installed
if ! command -v ansible &> /dev/null
then
    echo "Ansible is not installed. Installing..."
    # Update package lists for upgrades and new package installations
    sudo apt-get update
    # Install software-properties-common to get add-apt-repository
    sudo apt-get install -y software-properties-common
    # Add ansible PPA
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    # Install ansible
    sudo apt-get install -y ansible
fi

# Run the playbook
ansible-playbook --extra-vars "@config.yml" ./ansible/playbooks/setup_netpi.yml