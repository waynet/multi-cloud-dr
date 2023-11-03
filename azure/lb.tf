## Azure load balancer

# Container group load balancer
resource "azurerm_lb" "container_group_lb" {
  name = "container-group-lb"
  location = azurerm_resource_group.app_resource_group.location
  resource_group_name = azurerm_resource_group.app_resource_group.name
  frontend_ip_configuration {
    name = "container-group-IP"
    public_ip_address_id = azurerm_public_ip.my_public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "container_group_address_pool" {
  name = "container-group-address-pool"
  loadbalancer_id = azurerm_lb.container_group_lb.id
}

resource "azurerm_lb_rule" "container_group_lb_rules" {
  name = "container-group-lb-rules"
  loadbalancer_id = azurerm_lb.container_group_lb.id
  frontend_ip_configuration_name = azurerm_lb.container_group_lb.frontend_ip_configuration[0].name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.container_group_address_pool.id ]

  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
}

resource "azurerm_network_interface_backend_address_pool_association" "address_pool_association1" {
  network_interface_id    = azurerm_network_interface.frontend.id
  ip_configuration_name   = azurerm_network_interface.frontend.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.container_group_address_pool.id
}