# Service plan:
resource "azurerm_service_plan" "webappsp" {
  name = "webappserviceplan"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location = data.azurerm_resource_group.resource_group.location
  sku_name = "B1"
  os_type = "Windows"
}