terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "azure_sagan" {
  name     = "rg-azure-sagan-test"
  location = "East US"

  tags = {
    Environment = "Test"
    Purpose     = "Azure-Sagan-Testing"
    Project     = "azure-sagan"
  }
}

resource "azurerm_virtual_network" "azure_sagan_vnet" {
  name                = "vnet-azure-sagan-test"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.azure_sagan.location
  resource_group_name = azurerm_resource_group.azure_sagan.name

  tags = {
    Environment = "Test"
    Project     = "azure-sagan"
  }
}

resource "azurerm_subnet" "azure_sagan_subnet" {
  name                 = "subnet-azure-sagan-test"
  resource_group_name  = azurerm_resource_group.azure_sagan.name
  virtual_network_name = azurerm_virtual_network.azure_sagan_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "azure_sagan_public_ip" {
  name                = "pip-azure-sagan-test"
  resource_group_name = azurerm_resource_group.azure_sagan.name
  location            = azurerm_resource_group.azure_sagan.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    Environment = "Test"
    Project     = "azure-sagan"
  }
}

resource "azurerm_network_security_group" "azure_sagan_nsg" {
  name                = "nsg-azure-sagan-test"
  location            = azurerm_resource_group.azure_sagan.location
  resource_group_name = azurerm_resource_group.azure_sagan.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = "Test"
    Project     = "azure-sagan"
  }
}

resource "azurerm_network_interface" "azure_sagan_nic" {
  name                = "nic-azure-sagan-test"
  location            = azurerm_resource_group.azure_sagan.location
  resource_group_name = azurerm_resource_group.azure_sagan.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.azure_sagan_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.azure_sagan_public_ip.id
  }

  tags = {
    Environment = "Test"
    Project     = "azure-sagan"
  }
}

resource "azurerm_network_interface_security_group_association" "azure_sagan_nsg_association" {
  network_interface_id      = azurerm_network_interface.azure_sagan_nic.id
  network_security_group_id = azurerm_network_security_group.azure_sagan_nsg.id
}

resource "azurerm_linux_virtual_machine" "azure_sagan_vm" {
  name                = "vm-azure-sagan-test"
  resource_group_name = azurerm_resource_group.azure_sagan.name
  location            = azurerm_resource_group.azure_sagan.location
  size                = "Standard_B2s"
  admin_username      = "saganadmin"

  disable_password_authentication = true

  network_interface_ids = [
    azurerm_network_interface.azure_sagan_nic.id,
  ]

  admin_ssh_key {
    username   = "saganadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-11"
    sku       = "11-gen2"
    version   = "latest"
  }

  tags = {
    Environment = "Test"
    Project     = "azure-sagan"
  }
}

output "public_ip_address" {
  value = azurerm_public_ip.azure_sagan_public_ip.ip_address
}

output "ssh_connection_command" {
  value = "ssh saganadmin@${azurerm_public_ip.azure_sagan_public_ip.ip_address}"
}