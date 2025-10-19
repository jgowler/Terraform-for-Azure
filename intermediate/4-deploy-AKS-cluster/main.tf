### Network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "aksvnet"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  address_space       = ["12.0.0.0/16"]

  tags = {
    DeployedBy = "Terraform",
    Type       = "VNET"
  }
}
resource "azurerm_subnet" "aks_subnet" {
  name                 = "akssubnet"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["12.0.0.0/21"]
}

### AKS cluster
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "akscluster"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  dns_prefix          = "akscluster"

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_law.id
  }

  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "calico"
  }
  identity {
    type = "SystemAssigned"
  }

  default_node_pool {
    name           = "aksnodepool"
    vm_size        = "Standard_B2s"
    node_count     = 1
    os_sku         = "Ubuntu"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id

    tags = {
      DeployedBy = "Terraform",
      Type       = "AKSNode"
    }

  }
}
### Log analytics workspace
resource "azurerm_log_analytics_workspace" "aks_law" {
  name                = "akslaw"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    DeployedBy = "Terraform",
    Type       = "LogAnalyticsWorkspace"
  }
}
