# Web app:
resource "azurerm_windows_web_app" "webappwindows" {
    name = "webapp"
    resource_group_name = data.azurerm_resource_group.resource_group.name
    location = data.azurerm_resource_group.resource_group.location
    service_plan_id = var.service_plan_id

    site_config {}
}