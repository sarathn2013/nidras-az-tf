resource "azurerm_subnet" "test-subnet-1" {
  name                 = "test-subnet-1"
  resource_group_name  = azurerm_resource_group.test-rg.name
  virtual_network_name = azurerm_virtual_network.test-vn.name
  address_prefixes     = [var.subnet_addr]
}