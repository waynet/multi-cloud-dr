## Azure container App

resource "azurerm_container_app" "container_app" {
  name                         = "container-app"
  container_app_environment_id = azurerm_container_app_environment.container_app_env.id
  resource_group_name          = azurerm_resource_group.app_resource_group.name
  revision_mode                = "Single"

  # registry {
  #   server = "docker.io"    
  # }

  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 80
    traffic_weight {
      percentage = 100
    }
  }

  template {
    container {
      name   = "app"
      image  = "nginx:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}

resource "azurerm_container_app_environment" "container_app_env" {
  name                      = "container-app-env"
  location                   = azurerm_resource_group.app_resource_group.location
  resource_group_name        = azurerm_resource_group.app_resource_group.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
}

resource "azurerm_log_analytics_workspace" "log" {
  name                = "app-log-292929292"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
}

# Public IP Address for app-container
resource "azurerm_public_ip" "my_public_ip" {
  name                = "app-public-ip"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  allocation_method = "Static"
}