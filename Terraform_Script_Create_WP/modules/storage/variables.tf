
variable "storage_acct_prefix" {
  description = "name of the storage account - generated in main.tf"
  default     = "wpstg"
}

variable "storage_acct_container_prefix" {
  description = "name of the storage account container - generated in main.tf"
  default     = "blobstg"
}

variable "resource_group_name" {
  description = "Resource Group"
  default     = "test_rg"
}

variable "location" {
  description = "Storage Account Location"
  default     = "Australia East"
}

variable "tags" {
  description = "Resource tags"
  default = {
  }
}

variable "account_kind" {
  description = "BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  default     = "StorageV2"
}

variable "account_tier" {
  description = "Standard or Premium - for BlockBlobStorage and FileStorage needs to be set to Premium"
  default     = "Standard"
}

variable "replication_type" {
  description = "LRS, GRS, RAGRS, ZRS, GZRS or RAGZRS"
  default     = "LRS"
}

variable "access_tier" {
  description = "Hot or Cool"
  default     = "Hot"
}

variable "enable_https_traffic_only" {
  description = "enable HTTPS"
  default     = "true"
}

variable "allow_public_access" {
  description = "public access to all blobs or containers"
  default     = "true"
}

variable "hns" {
  description = "Hierarchical Namespace used for Data Lake"
  default     = "false"
}

variable "large_file_share" {
  description = "enable large file shares"
  default     = "true"
}


variable "min_tls" {
  description = "Minimum TLs Version"
  default     = "TLS1_2"
}