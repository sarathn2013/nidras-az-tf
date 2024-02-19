resource "azurerm_virtual_network" "test-vn" {
  name                = "test-vn"
  location            = azurerm_resource_group.test-rg.location
  resource_group_name = azurerm_resource_group.test-rg.name
  address_space       = [var.vn_addr]
  tags = {
    environment = var.env
  }
}