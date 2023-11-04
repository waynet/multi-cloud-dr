## Azure container App

# Azure Container App Instance
resource "azurerm_container_group" "app_container_group" {
  name                = "app-container-group"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  os_type             = "Linux"
  dns_name_label = "azure-app-ncirl"
  # dns_name_label_reuse_policy = "Noreuse"
  # ip_address_type = "Public"

  container {
    name   = "app-container"
    image  = "nginxinc/nginx-unprivileged"
    cpu    = "1"
    memory = "1.5"
    # ports {
    #   port     = 80
    #   protocol = "TCP"
    # }
  }

  container {
    name   = "caddy"
    image  = "caddy"
    cpu    = "1"
    memory = "1.5"

    ports {
      port     = 443
      protocol = "TCP"
    }

    ports {
      port     = 80
      protocol = "TCP"
    }

    volume {
      name                 = "caddy-data"
      mount_path           = "/data"
      storage_account_name = azurerm_storage_account.caddy111ppp.name
      storage_account_key  = azurerm_storage_account.caddy111ppp.primary_access_key
      share_name           = azurerm_storage_share.caddy.name
    }

    commands = [
      "caddy",
      "reverse-proxy",
      "--from",
      "azure-app-ncirl.northeurope.azurecontainer.io",
      "--to",
      "localhost:8080"
    ]
  }
}

# Public IP Address for app-container
resource "azurerm_public_ip" "my_public_ip" {
  name                = "app-public-ip"
  location            = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  allocation_method = "Dynamic"
}

# Caddy storage for enabling HTTPS
resource "azurerm_storage_account" "caddy111ppp" {
  name                      = "caddy111ppp"
  resource_group_name       = azurerm_resource_group.app_resource_group.name
  location                  = azurerm_resource_group.app_resource_group.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true
}
resource "azurerm_storage_share" "caddy" {
  name                 = "caddy-data"
  storage_account_name = azurerm_storage_account.caddy111ppp.name
  quota = 20
}