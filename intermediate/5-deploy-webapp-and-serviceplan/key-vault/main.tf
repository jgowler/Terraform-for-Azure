# Key Vault
resource "azurerm_key_vault" "kvwebapp" {
  name                = "keyvaultwebapp"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  sku_name            = "standard"
  tenant_id           = var.tenant_id
}
# Key Vault Access Policy
resource "azurerm_key_vault_access_policy" "kvapwebapp" {
  key_vault_id = azurerm_key_vault.kvwebapp.id
  tenant_id    = var.tenant_id
  object_id    = var.webapp_id

  certificate_permissions = ["Get", "List"]
}
