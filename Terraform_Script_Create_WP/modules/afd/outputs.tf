output "id" {
  description = "The ID of the AFD Profile."
  value       = azurerm_cdn_frontdoor_profile.afd_profile.id
}

output "hostname" {
  description = "Endpoint Hostname"
  value = azurerm_cdn_frontdoor_endpoint.afd_endpoint.host_name
}