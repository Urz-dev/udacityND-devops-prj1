provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "myrg_udacity" {
  name = "Azuredevops"
  
}

output "myrg" {
  value = data.azurerm_resource_group.myrg_udacity
}


resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.myrg_udacity.location
  resource_group_name = data.azurerm_resource_group.myrg_udacity.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.myrg_udacity.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  count = var.numvm
  name                = "${var.prefix}-nic${count.index}"
  resource_group_name = data.azurerm_resource_group.myrg_udacity.name
  location            = data.azurerm_resource_group.myrg_udacity.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  resource_group_name = data.azurerm_resource_group.myrg_udacity.name
  location            = data.azurerm_resource_group.myrg_udacity.location
  allocation_method   = "Dynamic"
}
resource "azurerm_network_security_group" "webserver" {
  name                = "prj1_webserver"
  location            = data.azurerm_resource_group.myrg_udacity.location
  resource_group_name = data.azurerm_resource_group.myrg_udacity.name
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "tls"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = azurerm_subnet.internal.address_prefixes
  }
}
resource "azurerm_availability_set" "avset" {
  name                         = "${var.prefix}avset"
  location                     = data.azurerm_resource_group.myrg_udacity.location
  resource_group_name          = data.azurerm_resource_group.myrg_udacity.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}
resource "azurerm_linux_virtual_machine" "main" {
  count = var.numvm
  name = "${var.prefix}-vm${count.index}"
  resource_group_name             = data.azurerm_resource_group.myrg_udacity.name
  location                        = data.azurerm_resource_group.myrg_udacity.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main[count.index].id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}