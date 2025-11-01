# Log Analytics Workspace:
resource "azurerm_log_analytics_workspace" "lawwebapp" {
    name = "lawwebapp"
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location = data.azurerm_resource_group.resource_group.location

    sku = "PerGB2018"
}