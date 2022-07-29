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
  name                = "${var.prefix}-nic"
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
resource "azurerm_linux_virtual_machine" "main" {
  name                            = "${var.prefix}-vm"
  resource_group_name             = data.azurerm_resource_group.myrg_udacity.name
  location                        = data.azurerm_resource_group.myrg_udacity.location
  size                            = "Standard_D2s_v3"
  admin_username                  = "${var.username}"
  admin_password                  = "${var.password}"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.main.id,
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