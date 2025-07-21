#!/bin/bash

set -e

echo "=== Sagan Test Environment Deployment ==="

# Check if required tools are installed
command -v terraform >/dev/null 2>&1 || { echo "Error: terraform is required but not installed."; exit 1; }
command -v ansible-playbook >/dev/null 2>&1 || { echo "Error: ansible-playbook is required but not installed."; exit 1; }

# Check if SSH key exists
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    echo "Error: SSH public key not found at ~/.ssh/id_rsa.pub"
    echo "Please generate an SSH key pair with: ssh-keygen -t rsa -b 4096"
    exit 1
fi

echo "Step 1: Deploying Azure infrastructure..."
cd terraform/
terraform init
terraform plan
terraform apply -auto-approve

# Get the public IP from terraform output
PUBLIC_IP=$(terraform output -raw public_ip_address)
echo "VM Public IP: $PUBLIC_IP"

# Wait for VM to be accessible
echo "Step 2: Waiting for VM to be accessible..."
for i in {1..30}; do
    if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no saganadmin@$PUBLIC_IP "echo 'VM is ready'" 2>/dev/null; then
        echo "VM is accessible!"
        break
    fi
    echo "Attempt $i: VM not ready yet, waiting 10 seconds..."
    sleep 10
done

cd ../ansible/

echo "Step 3: Running system setup..."
ansible-playbook -i inventory.yml -e vm_public_ip=$PUBLIC_IP playbooks/setup-system.yml

echo "Step 4: Installing Sagan..."
ansible-playbook -i inventory.yml -e vm_public_ip=$PUBLIC_IP playbooks/install-sagan.yml

echo "Step 5: Installing Suricata..."
ansible-playbook -i inventory.yml -e vm_public_ip=$PUBLIC_IP playbooks/install-suricata.yml

echo "Step 6: Testing installations..."
ansible-playbook -i inventory.yml -e vm_public_ip=$PUBLIC_IP playbooks/test-services.yml

echo ""
echo "=== Deployment Complete ==="
echo "SSH Access: ssh saganadmin@$PUBLIC_IP"
echo "Sagan logs: /var/log/sagan/"
echo "Suricata logs: /var/log/suricata/"
echo "Sagan rules: /opt/sagan-rules/"
echo "Suricata rules: /etc/suricata/rules/"
echo ""