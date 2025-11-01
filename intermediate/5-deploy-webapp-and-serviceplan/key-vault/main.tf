# Key Vault
resource "azurerm_key_vault" "kvwebapp" {
    name = "keyvaultwebapp"
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location = data.azurerm_resource_group.resource_group.location
    sku_name = "standard"
    tenant_id = var.tenant_id
}
# Key Vault Access Policy
