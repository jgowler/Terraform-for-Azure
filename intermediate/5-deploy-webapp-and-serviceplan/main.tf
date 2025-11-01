module "StorageAccount" {
    source = "./storage-account"
    resource_group = data.azurerm_resource_group.resource_group.name
}
module "LogAnalyticsWorkspace" {
    source = "./log-analytics-workspace"
    resource_group = data.azurerm_resource_group.resource_group.name
}
module "ServicePlan" {
    source = "./service-plan"
    resource_group = data.azurerm_resource_group.resource_group.name
}
module "WebApp" {
    source = "./web-app"
    resource_group = data.azurerm_resource_group.resource_group.name
    service_plan_id = module.ServicePlan.ServicePlan
}