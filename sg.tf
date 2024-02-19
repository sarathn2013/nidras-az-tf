resource "azurerm_network_security_group" "test-sg-1" {
  name                = "test-sg-1"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name

  tags = {
    environment = var.env
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
  source_address_prefix       = var.source_address
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.test-rg.name
  network_security_group_name = azurerm_network_security_group.test-sg-1.name
}

resource "azurerm_subnet_network_security_group_association" "test-sga-1" {
  subnet_id                 = azurerm_subnet.test-subnet-1.id
  network_security_group_id = azurerm_network_security_group.test-sg-1.id
}