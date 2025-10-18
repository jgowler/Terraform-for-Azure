### Network config:
resource "azurerm_subnet" "SUBNET_linux" {
  name                 = "subnet-linux"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.VNET_linux.name
  address_prefixes     = ["11.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "SGA_linux" {
  subnet_id                 = azurerm_subnet.SUBNET_linux.id
  network_security_group_id = azurerm_network_security_group.NSG_linux.id
}

resource "azurerm_virtual_network" "VNET_linux" {
  name                = "vnet-Linux"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  address_space       = ["11.0.0.0/16"]

}
resource "azurerm_network_security_group" "NSG_linux" {
  name                = "vnet-linux"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.source_address
    destination_address_prefix = "*"
  }
}
resource "azurerm_network_interface" "NIC_linux" {
  name                = "nic-linux"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location

  ip_configuration {
    name                          = "PrivatePublic"
    subnet_id                     = azurerm_subnet.SUBNET_linux.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.PIP_linux.id
  }
}
resource "azurerm_public_ip" "PIP_linux" {
  name                = "pip-linux"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

### SSH Key:
resource "tls_private_key" "local_to_linux" {
  algorithm = "ED25519"
}

### Save the key locally:
resource "local_file" "private_key" {
  content  = tls_private_key.local_to_linux.private_key_openssh
  filename = "${path.module}/local_to_linux"
}

### Linux VM:
resource "azurerm_linux_virtual_machine" "VM_linux" {
  name                = "vm-linux"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.NIC_linux.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.local_to_linux.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
