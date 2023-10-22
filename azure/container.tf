## Azure container App

# Azure Container App Instance
resource "azurerm_container_group" "app_container_group" {
  name                = "app-container-group"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  os_type             = "Linux"

  container {
    name   = "app-container"
    image  = "httpd:latest"
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
  allocation_method = "Dynamic"
}