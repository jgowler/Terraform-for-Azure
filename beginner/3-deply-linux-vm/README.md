# Beginner projects
---
1. Create Resource Group and Storage account
2. VNets, Subnets, and NSG's
3. Deploy a Linux VM along with SSH key.
---
## Part 3 - Deploy a Linux VM along with SSH key
---
The final part of the beginner project section will be the deployment of a linux VM. The following resources are required to accomplish this:
Resource Group
VNET
Subnet
NIC
NSG

As the resource group has already been created this can be referenced in the deplyment using the `data.tf` file created earlier.
---
The network side will look similar to the previous part with the addition of a `security_rule` to allow SSH connection from my public IP address to the VM. This will be added to the NSG which is attached the to Subnet:
```
...
security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
...
```
---
As a key pair will be created to allow the SSH connection I will add the `tls_private_key` provider to the `providers.tf` file to allow resources of this kind to be created:
```
...
    tls = {
        source = "hashicorp/tls"
        version = "4.1.0"
        }
...
```
This can be added underneath the Azure provider as a required provider. Creating the resource is very simple:
```
resource "tls_private_key" "local_to_linux" {
  algorithm = "ED25519"
}
```
The private key is then saved locally. For testing purposes I will save it to the module folder:
```
resource "local_file" "private_key" {
  content = tls_private_key.local_to_linux.private_key_openssh
  filename = "${path.module}/local_to_linux"  
}
```
Once the key pair is created the public key can be referenced in the VM build using the following block:
```
resource "azurerm_linux_virtual_machine" "VM_linux" {
...
admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.local_to_linux.public_key_openssh
  }
...
```
Once the VM is up and running an SSH connection is possible using the following from the directory the private key is kept (this can / should be elsewhere):
`ssh -i local_to_linux adminuser@<vm public ip>`
---
And that is the end of the beginner projects. This was just a striaght forward set of tasks where more complexity could be added but for the sake of showing some quick deplyments this will do for now. Now, on to the intermediate tasks.
---