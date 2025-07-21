# Azure Sagan - Automated Security Testing Environment

This repository contains automated deployment scripts for setting up a test environment with Sagan log analysis engine and Suricata IDS on Azure using Terraform and Ansible. The environment is designed for testing security rules and can be easily deployed and torn down to minimize costs.

## Features

- 🔧 **Automated Infrastructure**: One-command deployment and teardown
- 🛡️ **Security Tools**: Pre-configured Sagan and Suricata installations
- 📋 **Rule Management**: Includes Quadrant Security's Sagan rules repository
- 💰 **Cost Efficient**: Easy teardown to avoid ongoing charges
- 🔒 **Secure**: SSH key authentication, dedicated users, network security groups

## Prerequisites

Before using this repository, you need to install and configure the following tools:

### 1. Azure CLI

**Ubuntu/Debian:**
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

**Windows:**
Download and install from: https://aka.ms/installazurecliwindows

**macOS:**
```bash
brew install azure-cli
```

**Verify installation:**
```bash
az --version
```

**Login to Azure:**
```bash
az login
```

### 2. Terraform

**Ubuntu/Debian:**
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

**Windows:**
Download from: https://releases.hashicorp.com/terraform/

**macOS:**
```bash
brew install terraform
```

**Alternative (any platform):**
```bash
# Download manually
wget https://releases.hashicorp.com/terraform/1.6.6/terraform_1.6.6_linux_amd64.zip
unzip terraform_1.6.6_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

**Verify installation:**
```bash
terraform version
```

### 3. Python & Ansible

**Install Python dependencies:**
```bash
# Install Python 3 and pip (if not already installed)
sudo apt update
sudo apt install python3 python3-pip

# Install required Python packages
pip3 install -r requirements.txt
```

**Verify Ansible installation:**
```bash
ansible-playbook --version
```

### 4. SSH Key Pair

Generate an SSH key pair for VM access:
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/schlangens/azure-sagan/
cd azure-sagan
```

### 2. Deploy the Environment
```bash
./scripts/deploy.sh
```

The script will:
- Create Azure VM with Debian 11
- Install and configure Sagan log analysis engine
- Install and configure Suricata IDS
- Clone the latest Quadrant Security rules
- Test both services
- Display SSH connection details

### 3. Connect to the VM
```bash
# Use the IP address provided by the deployment script
ssh saganadmin@<PUBLIC_IP>
```

### 4. Monitor Services
```bash
# Check service status
sudo systemctl status sagan
sudo systemctl status suricata

# View logs
sudo tail -f /var/log/sagan/sagan.log
sudo tail -f /var/log/suricata/fast.log
```

### 5. Tear Down the Environment
```bash
./scripts/teardown.sh
```

**⚠️ Important:** Always run the teardown script when finished to avoid ongoing Azure charges.

## Directory Structure

```
azure-sagan/
├── terraform/
│   └── main.tf                 # Azure infrastructure definition
├── ansible/
│   ├── inventory.yml           # Ansible inventory configuration
│   ├── playbooks/
│   │   ├── setup-system.yml    # System updates and base configuration
│   │   ├── install-sagan.yml   # Sagan installation and configuration
│   │   ├── install-suricata.yml# Suricata installation and configuration
│   │   └── test-services.yml   # Service testing and validation
│   └── templates/
│       ├── sagan.yaml.j2       # Sagan configuration template
│       ├── sagan.service.j2    # Sagan systemd service template
│       └── suricata.service.j2 # Suricata systemd service template
├── scripts/
│   ├── deploy.sh              # Automated deployment script
│   └── teardown.sh            # Environment destruction script
├── requirements.txt           # Python dependencies
├── CONTRIBUTING.md            # Contribution guidelines
└── README.md                  # This file
```

## VM Directory Structure

### Sagan Directories
- **Configuration**: `/etc/sagan/`
  - Main config: `/etc/sagan/sagan.yaml`
- **Rules**: `/opt/sagan-rules/` (Quadrant Security repository)
- **Logs**: `/var/log/sagan/`
  - Main log: `/var/log/sagan/sagan.log`
- **Runtime**: `/var/run/sagan/`
- **Data**: `/var/lib/sagan/`
- **Binary**: `/usr/bin/sagan`

### Suricata Directories
- **Configuration**: `/etc/suricata/`
  - Main config: `/etc/suricata/suricata.yaml`
- **Rules**: `/etc/suricata/rules/`
  - Test rules: `/etc/suricata/rules/test.rules`
  - Downloaded rules: `/var/lib/suricata/rules/`
- **Logs**: `/var/log/suricata/`
  - Fast log: `/var/log/suricata/fast.log`
  - EVE log: `/var/log/suricata/eve.json`
- **Runtime**: `/var/run/suricata/`
- **Data**: `/var/lib/suricata/`
- **Binary**: `/usr/bin/suricata`

## Configuration

### Sagan Configuration
- Located at `/etc/sagan/sagan.yaml`
- Listens on UDP port 514 for syslog messages
- Uses rules from `/opt/sagan-rules/`
- Outputs to file and syslog

### Suricata Configuration
- Located at `/etc/suricata/suricata.yaml`
- Monitors all network interfaces
- Includes test rules for basic traffic detection
- Outputs to fast.log and eve.json

## Troubleshooting

### Check Service Status
```bash
sudo systemctl status sagan
sudo systemctl status suricata
```

### View Service Logs
```bash
sudo journalctl -u sagan -f
sudo journalctl -u suricata -f
```

### Restart Services
```bash
sudo systemctl restart sagan
sudo systemctl restart suricata
```

### Validate Configuration
```bash
# Check Sagan configuration (if available)
sudo sagan -T -f /etc/sagan/sagan.yaml

# Check Suricata configuration
sudo suricata -T -c /etc/suricata/suricata.yaml
```

### Common Issues

**Azure Authentication:**
```bash
az login
az account show
```

**SSH Connection Issues:**
- Ensure your public IP is correct
- Check that port 22 is open in the security group
- Verify SSH key permissions: `chmod 600 ~/.ssh/id_rsa`

**Service Start Issues:**
- Check configuration file syntax
- Verify user permissions on directories
- Review service logs for specific errors

## Cost Management

**Estimated Costs:**
- Standard_B2s VM: ~$30-60/month if left running
- Standard SKU Public IP: ~$3-5/month
- Storage and networking: ~$5-10/month

**Cost Savings Tips:**
- Always use the teardown script when finished
- Consider using smaller VM sizes for basic testing
- Monitor usage with `az account get-access-token` and Azure Cost Management

## Security Considerations

- VM uses SSH key authentication only (no passwords)
- Services run under dedicated users (`sagan` and `suricata`)
- Network security group restricts access to SSH (port 22) only
- All sensitive data should be removed before committing to public repositories

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test deployment and teardown
5. Submit a pull request

## License

This project is provided as-is for educational and testing purposes. Please review and comply with the licenses of the included security tools (Sagan and Suricata) and rule sets.

## Support

For issues related to:
- **Sagan**: Visit [Quadrant Security's Sagan repository](https://github.com/quadrantsec/sagan)
- **Suricata**: Visit [Suricata's official documentation](https://suricata.readthedocs.io/)
- **This automation**: Open an issue in this repository
