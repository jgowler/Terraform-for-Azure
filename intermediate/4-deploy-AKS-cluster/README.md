# Intermediate projects
---
4. Deploy an Azure Kubernetes Service (AKS) cluster
5. Deply an Azure Web App and App Service Plan
6. Create an Azure SQL Database with a Private Endpont
7. Deply an Azure Container Registry

---
## Part 4 - Deploy an Azure Kubernetes Service (AKS) cluster
---

To deploy an AKS cluster the following resources are required:
- Resource Group (already created and referenced using the data block)
- VNET
- Subnet
- AKS cluster

As VNETs, Subnets, and NSGs have already been covered the config for these will be very similar to create the AKS cluster so I will not be going into much detail explaining this part again. This README.md will be focussing on the details of the deployment of the cluster itself.

In this part I will be deploying a VNET and Subnet for the cluster so will need to add the following block to the cluster config:

```
resource "azurerm_kubernetes_cluster" "aks_cluster" {
...
network_profile {
  network_plugin = "azure"
}

default_node_pool {
  pod_subnet_id = azurerm_subnet.aks_subnet.id
}
...
}
```
This will ensure that the cluster will use the deployed VNET and Subnet bu using the `Azure CNI plugin`. If this were not specified the `kubenet` plugin will be used by default and no VNET or subnet would be required for the deployment.

---

This cluster will be very basic as a way of testing the deployment script, with a single node deployed, a system assigned identity, and logs exported to Logs Analytics Workspace. What is different to the previous parts is the inclusion of `outputs`.

`Outputs` will provide me with the information about the deployment after it has been created, such as the kubeconfig information, system assigned client id, and the API server endpoint. Sensitive information will be protected witht he `sensitive = true` option in the `outputs.tf` file, this information can be manually accessed after deployment using the command `terraform output -raw aks_kubeconfig`. The `aks_kubeconfig` part can be changed for the output of your choice.

As `aks_kubeconfig` is the only sensitive output in the `outputs.tf` file the rest of the outputs will be displayed after the deployment has completed.

---

The `oms_agent` will deploy the Azure Monitor agent to the cluster nodes and pods. It does this by deploying a `DaemonSet` on all AKS nodes to collect telemetry data. The agent will collect metrics, collect logs, and send this data to the Logs Analytics Workspace.

---

Once the deployment is complete the cluster will be accessible from the cloud shell using hte following commands:

```
- Set the cluster subscription
az account set --subscription <subscription ID>

- Download cluster credentials
az aks get-credentials --resource-group terraform-project --name akscluster --overwrite-existing

- List all nodes
kubectl get nodes
```
---

And that is it, an AKS cluster deployed to Azure using Terraform. There are many configuration options that can be applied in the deployment but for now the basics are covered in this part of the projects. Anything else that is required can be added by simply including it in the AKS code block, such as `auto_scaling_enabled`, `max_pods`, etc.

---
