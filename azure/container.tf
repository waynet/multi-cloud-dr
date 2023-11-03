## Azure container App

# Azure Container App Instance
resource "azurerm_container_group" "app_container_group_1" {
  name                = "app-container-group-1"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  os_type             = "Linux"
  # dns_name_label = "azure-app-ncirl"

  container {
    name   = "app-container-1"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "0.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
resource "azurerm_container_group" "app_container_group_2" {
  name                = "app-container-group-2"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  os_type             = "Linux"
  # dns_name_label = "azure-app-ncirl"

  container {
    name   = "app-container-2"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "0.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}
resource "azurerm_container_group" "app_container_group_3" {
  name                = "app-container-group-3"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  os_type             = "Linux"
  # dns_name_label = "azure-app-ncirl"

  container {
    name   = "app-container-3"
    image  = "nginx:latest"
    cpu    = "0.5"
    memory = "0.5"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}

# Public IP Address for app-container
resource "azurerm_public_ip" "my_public_ip" {
  name                = "app-public-ip"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  allocation_method = "Static"
}