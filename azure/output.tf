## Output for testing

# output "container_ip" {
#   value = azurerm_container_group.app_container_group.ip_address
# }

# output "container_fqdn" {
#   value = azurerm_container_group.app_container_group.fqdn
# }

output "container_group_lb_fqdn" {
  value = azurerm_public_ip.my_public_ip.fqdn
}
# output "container_group_lb_ip" {
#   value = azurerm_lb.container_group_lb.ip_address
# }
output "azurerm_container_app_url" {
  value = azurerm_container_app.container_app.latest_revision_fqdn
}