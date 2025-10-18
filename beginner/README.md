# Beginner projects
---
0. Set up environment
1. Create Resource Group and Storage account
2. VNets, Subnets, and NSG's
3. Deploy a Linux VM along with SSH key.
---
## Part 0 - Set up environment
---
Each project will use a similar setup; the main deployment script will contain the project specific informaiton for whatever resources will be deployed and the outputs may vary, but the variables and providers will remain the same.

The files that will be created for each step in this project are as follows:
```
main.tf - The actualy infrastructure that will be created. This may be broken down into smaller modules and called from this file.
providers.tf - The providers used to interact with platforms and services (in this example Azure).
variables.tf - Declare input variables used throughout the deployment.
outputs.tf - Makes output values created from the deployment available to other configurations or modules.
secrets.tfvars - This will contain sensitive information that will not be made available, such as the Service Principal secret. These values will overwrite the defaul value of the variable that shares the same name in the variables.tf file.
```

A Service Principal will also be used to deploy the resources to Azure. The client id and client secret will be stored in the secrets.tfvars file to be referenced by the script.

---

Creating the Service Principal:
- Entra ID > App registrations > New registration.
Name: "sp-terraform"
Who can use this application or access this API?: "Accounts in this organizational directory only (Default Directory only - Single tenant)"
Register

Create the secret for the Service Principal:
- Entra ID > App reguistrations > "sp-terraform" > Certificates & secrets > client secrets > New client secret:
Description: "Terraform"
Expires: "90 days (3 months)" - This can be as long as is needed.
Add

Copy the Value of the secret now as it will not be available once this page is refreshed. The `Application (client) ID` will also be required, this can be seen in the `Overview` tab.

Grant the Service Principal permissions to deploy:
**NOTE:** For the purposes of creating the Resoucre Group in part 1 the service principal will be granted Contributer role at subscription level. For the subsequent parts of this ongoing project the service principal will be granted this elevated role to an exisiting resource group to ensure it does not have permissions outside of this scope to help with following the security principal of least priviledge. If later on the service principal requires elevated permissions this will be granted ad-hoc.
- Subscriptions > Select subscription > Access control (IAM) > + Add > Add role assignment:
Role: Priviledged adminstrator roles > "Contributer" > Next
Members: Assign access to > User,groups, or service principal > + Select members > "sp-terraform" > Review + assign

The `providers.tf` file will reference the subscription ID, tenant ID, client ID, and client secret. These values will be stored in the `secrets.tfvars` file which will then overwrite their variable name equivelent in the `variables.tf` file before and during the deployment.

---
## Set up providers
---
The documentation to set up the provider for azure can be found here:
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

The first block can be copied over to the `providers.tf` file:

```
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.49.0"
    }
  }
}
```
The second part will need more information to be able to connect Terraform to Azure using the Service Principal:
```
provider "azurerm" {
    features {}
    subscription_id = var.subscription_id
    tenant_id = var.tenant_id
    client_id = var.service_account_id
    client_secret = var.service_account_secret
}
```
The `features {}` block is used to add advanced options, such as the following for API management:
```
 api_management {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted         = true
    }
```

For now, this will not be used. The other values mentioned however will be. The values prepended with "var." will call on the `variables.tf` file for their respoective values, but as these are replaced with the values of the `secrets.tfvars` file the values of the latter will ultimately be used. The values needed for these are added to the `secrets.tfvars` file with the same name as what they are given in the `variables.tf` file.

---
With this set up now it is time to deploy the resource group and the storage account.