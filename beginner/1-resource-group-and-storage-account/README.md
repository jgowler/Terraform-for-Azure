# Beginner projects
---
1. Create Resource Group and Storage account
2. VNets, Subnets, and NSG's
3. Deploy a Linux VM along with SSH key.
---
## Part 1 - Create Resource Group and Storage account
---
As the providers are specified in `providers.tf` and variables in `variables.tf` the resources to be created will be defined in the `main.tf` file.

There are two required arguments for a resource group, the name and the location.
```
resource "azurerm_resource_group" "part-1-group" {
    name = "part-1-group"
    location = "UK South"
}
```
And that is all that is required. Other information can be added which would be helpful, such as tags, which would be added in the same way the name and locatin are added. The only difference would be that as tags can hold multiple values a pair of {} curly braces would be used to denote a list:
```
tags = {
        Project = "Terraform"
        Type = "ResourceGroup"
    }
```

All required arguments can be found in the documentation for the resource being created.

---
The block for the storage account follows suit with required fields, but as the storage account will be created within the resource group that will be deployed we can reference information about the resource group to ensure that Terraform will attempt to create the storage account once the resource group is created:
```
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
```

Both the resource name and location will only be output once the resource has been created. This information could be provided manually if it were to be deployed in an already existing resource group but as this is not the case we know that one must be created before the other.

---
To deploy these resources `terraform init` will be required to donwload the required providers. Once this is confirmed on-screen `terraform plan` is run to get an overview of what will be created.

When everything looks fine it is time to use `terraform apply` to deploy the resources. A prompt will appear to request a "yes" to continue.

When complete the following confirmation is shown:

`Apply complete! Resources: 2 added, 0 changed, 0 destroyed.`
---