# Beginner projects
---
1. Create Resource Group and Storage account
2. VNets, Subnets, and NSG's
3. Deploy a Linux VM along with SSH key.
---
## Part 2 - VNets, Subnets, and NSG's
---
**NOTE:** The previously assigned Contributer role to the subscription for the service principal has now been removed and replaced with elevated permissions to a specified resource group. The service principal will not have permission to create outside of this resource group.
---
### Using the existing resource group in the deployment
---
To allow Terraform to know about this group and use its information a data blokc will be needed to get the information:
```
data "azurerm_resource_group" "resource_group" {
  name = var.resource_group
}
```
Using this block will allow the resources being deployed to be able to refence the information needed for deplyment, such as the resource group name and its location:
```
...
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
...
```
To ensure this resource group is available moving forward, a `data.tf` file will be created with this information.