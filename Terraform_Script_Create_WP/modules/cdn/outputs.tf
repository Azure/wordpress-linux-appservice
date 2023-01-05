output "cdn_profile_id" {
  description = "TThe ID of the CDN Profile."
  value       = azurerm_cdn_profile.cdn_profile.id
}

output "cdn_endpoint_id" {
  description = "The ID of the CDN Endpoint."
  value       = azurerm_cdn_endpoint.cdn_endpoint.id
}

 output "hostname" {
  description = "URL of the CDN endpoint"
  value = azurerm_cdn_endpoint.cdn_endpoint.fqdn
 } 


