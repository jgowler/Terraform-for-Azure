# Storage account:
resource "azurerm_storage_account" "strgacc-webapp" {
    name = "strgaccwebapp"
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location = data.azurerm_resource_group.resource_group.location
    account_kind = "StorageV2"
    account_tier = "Standard"
    account_replication_type = "LRS"
}
# Storage container Logs:
resource "azurerm_storage_container" "container-applogs" {
    name = "container-applogs"
    storage_account_id = azurerm_storage_account.strgacc-webapp.id
    container_access_type = "private"
}