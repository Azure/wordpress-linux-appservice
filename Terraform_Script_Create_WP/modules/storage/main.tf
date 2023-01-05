# see https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

#create a random name
resource "random_id" "storage_account_name_id" {
  byte_length = 8
}

#Create the storage account
resource "azurerm_storage_account" "storage_account" {
  name                      = "${var.storage_acct_prefix}${lower(random_id.storage_account_name_id.hex)}"
  depends_on                = [var.storage_depends_on]
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.account_kind
  account_tier              = var.account_tier
  account_replication_type  = var.replication_type
  access_tier               = var.access_tier
  enable_https_traffic_only = var.enable_https_traffic_only
  //allow_blob_public_access  = var.allow_public_access
  is_hns_enabled            = var.hns
  min_tls_version           = var.min_tls
  tags                      = var.tags

  network_rules {
    default_action          = "Allow"
    bypass                  = ["AzureServices"]
  }
}

#Create the storage account BLOB container
resource "azurerm_storage_container" "storage_blob_container" {
  name                  = "${var.storage_acct_container_prefix}${lower(random_id.storage_account_name_id.hex)}"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "container"
}