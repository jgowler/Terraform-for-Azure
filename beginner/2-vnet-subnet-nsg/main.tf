resource "azurerm_virtual_network" "VNET" {
  name                = "VNET1"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  address_space       = ["10.0.0.0/16"]

  subnet {
    name             = "SUBNET1"
    address_prefixes = ["10.0.1.0/24"]
    security_group   = azurerm_network_security_group.NSG1.id
  }

  tags = {
    ResourceGroup = data.azurerm_resource_group.resource_group.name
    Type          = "VirtualNetwork"
  }
}
resource "azurerm_network_security_group" "NSG1" {
  name                = "NSG1"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}
