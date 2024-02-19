resource "azurerm_resource_group" "test-rg" {
  name     = "test-rg"
  location = var.region
  tags = {
    environment = var.env
  }
}

