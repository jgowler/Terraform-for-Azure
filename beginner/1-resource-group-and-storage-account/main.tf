resource "azurerm_resource_group" "part-1-group" {
    name = "part-1-group"
    location = "UK South"
    tags = {
        Project = "Terraform"
        Type = "ResourceGroup"
    }
}

resource "azurerm_storage_account" "example" {
  name                     = "saname64632685463"
  resource_group_name      = azurerm_resource_group.part-1-group.name
  location                 = azurerm_resource_group.part-1-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Project = "Terraform"
    Type = "StorageAccount"
  }
}