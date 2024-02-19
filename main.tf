terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test-rg" {
  name     = "test-rg"
  location = "East US"
  tags = {
    environment = "dev"
  }
}


resource "azurerm_virtual_network" "test-vn" {
  name                = "test-vn"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "test-subnet-1" {
  name                 = "test-subnet-1"
  resource_group_name  = azurerm_resource_group.test-rg.name
  virtual_network_name = azurerm_virtual_network.test-vn.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "test-sg-1" {
  name                = "test-sg-1"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "test-sr-1" {
  name                        = "test-sr-1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "your_public_ip"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.test-rg.name
  network_security_group_name = azurerm_network_security_group.test-sg-1.name
}

resource "azurerm_subnet_network_security_group_association" "test-sga-1" {
  subnet_id                 = azurerm_subnet.test-subnet-1.id
  network_security_group_id = azurerm_network_security_group.test-sg-1.id
}

resource "azurerm_public_ip" "test-pub-ip-1" {
  name                = "test-pub-ip-1"
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "test-nic" {
  name                = "test-nic"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.test-subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.test-pub-ip-1.id
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_linux_virtual_machine" "test-vm" {
  name                = "test-vm"
  resource_group_name = azurerm_resource_group.test-rg.name
  location            = azurerm_resource_group.test-rg.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.test-nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("/Users/sarathchandranidra/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
