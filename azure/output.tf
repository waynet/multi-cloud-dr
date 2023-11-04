## Output for testing

output "container_ip" {
  value = azurerm_container_group.app_container_group.ip_address
}

output "container_fqdn" {
  value = azurerm_container_group.app_container_group.fqdn
}