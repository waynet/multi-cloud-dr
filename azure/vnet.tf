## Azure Virtual Network

# Azure resource group
resource "azurerm_resource_group" "app_resource_group" {
  name     = "app-resource-group"
  # Ireland region data centre
  location = "North Europe"
}

# Azure Virtual Network
resource "azurerm_virtual_network" "app_vnet" {
  name                = "app-vnet"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  address_space       = [var.vnet_ip]
}

# Public subnets
resource "azurerm_subnet" "public_subnet_1" {
  name                 = "public_subnet_1"
  resource_group_name  = azurerm_resource_group.app_resource_group.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_ip, 4, 3)]
}

resource "azurerm_subnet" "public_subnet_2" {
  name                 = "public_subnet_2"
  resource_group_name  = azurerm_resource_group.app_resource_group.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_ip, 4, 2)]
}

resource "azurerm_subnet" "public_subnet_3" {
  name                 = "public_subnet_3"
  resource_group_name  = azurerm_resource_group.app_resource_group.name
  virtual_network_name = azurerm_virtual_network.app_vnet.name
  address_prefixes     = [cidrsubnet(var.vnet_ip, 4, 1)]
}