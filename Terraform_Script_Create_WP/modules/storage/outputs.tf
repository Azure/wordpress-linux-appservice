output "id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.storage_account.id
}

output "primary_access_key" {
  description = "Storage Account Primary access key"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Storage Account Secondary access key"
  value       = azurerm_storage_account.storage_account.secondary_access_key
  sensitive   = true
}


output "primary_connection_string" {
  description = "Storage Account Primary Connection string"
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "Storage Account Secondary Connection string"
  value       = azurerm_storage_account.storage_account.secondary_connection_string
  sensitive   = true
}

output "name" {
  description = "Storage Account Name"
  value       = azurerm_storage_account.storage_account.name
}

output "primary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the primary location"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "secondary_blob_endpoint" {
  description = "The endpoint URL for blob storage in the secondary location."
  value       = azurerm_storage_account.storage_account.secondary_blob_endpoint
}

output "storage_blob_container_name" {
  description = "The storage blob container created."
  value       = azurerm_storage_container.storage_blob_container.name
}