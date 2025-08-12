/*
General Settings
*/
variable "tags" {
  description = "resource tags"
  default = {
    AppProfile = "Wordpress"
  }
}

variable "resource_group_name" {
  description = "Resource Group Name"
  default     = "wordpress-appsvc-rg"
}

variable "resource_group_location" {
  description = "Resource Group Location"
  default     = "West US"
}

/*
Feature Flags
*/
#Conditionally Deploy the Azure Storage account
variable "deploy_azure_storage_account" {
  description = "Deploy Storage account for use by Wordpress"
  default     = false
  type        = bool
}

#Conditionally Deploy Azure Frontdoor
variable "deploy_azure_frontdoor" {
  description = "Deploy Azure Front Door - Must not deploy CDN as well"
  default     = false
  type        = bool
}

#Conditionally Deploy the CDN
variable "deploy_azure_cdn" {
  description = "Deploy CDN - Must not deploy AFD as well"
  default     = false
  type        = bool
}

/*
Storage Settings
*/
#Storage prefix
variable "app_service_storage_account_prefix" {
  description = "Storage Account Name Prefix"
  default     = "wpstg"
}

#Storage BLOB container prefix
variable "app_service_storage_blob_prefix" {
  description = "Storage Container BLOB Prefix"
  default     = "blobstg"
}


/*
Network Settings
*/
variable "virtual_network_name" {
  description = "Virtual Network Name"
  default     = "wp-app-vnet"
}

variable "virtual_network_address_space" {
  description = "CIDR Block of the VNet"
  default     = "10.0.0.0/16"
}

variable "virtual_network_app_subnet_name" {
  description = "name of App Subnet"
  default     = "wp-app-subnet"
}

variable "virtual_network_app_subnet_cidr" {
  description = "cidr for App Subnet"
  default     = "10.0.0.0/24"
}

variable "virtual_network_db_subnet_name" {
  description = "name of db Subnet"
  default     = "wp-db-subnet"
}

variable "virtual_network_db_subnet_cidr" {
  description = "cidr for Db Subnet"
  default     = "10.0.1.0/24"
}

/*
App Service Settings
*/
variable "app_service_hosting_plan_name" {
  description = "App service plan name"
  default     = "wp-appsvc-plan"
}

variable "app_service_web_app_prefix" {
  description = "App service prefix"
  default     = "wp-app-web"
}

variable "app_service_hosting_plan_sku" {
  description = "App service SKU"
  default     = "P1v2"
}

variable "app_service_workers" {
  description = "App service Workers"
  default     = 1
}

variable "app_service_alwayson" {
  description = "App service Always On"
  default     = true
}

variable "app_service_docker_registry_url" {
  description = "Docker Registry URL"
  default     = "mcr.microsoft.com"
}

/*
MySQL Settings
*/
variable "mysql_server_edition" {
  description = "MYSQL DB Server Edition"
  default     = "GeneralPurpose"
}

variable "mysql_server_name" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "mysql_server_username" {
  description = "DB Server Username"
  default     = "wpdbadmusr"
}

variable "mysql_server_password" {
  description = "DB Server Password"
  sensitive   = true
}

variable "mysql_db_storage_size_gb" {
  description = "SQL DB Storage Size"
  default     = "128"
}

variable "mysql_db_storage_iops" {
  description = "SQL DB Storage IOPS"
  default     = "700"
}

variable "mysql_db_storage_autogrow" {
  description = "SQL DB Storage Autogrow"
  default     = "Enabled"
}

variable "mysql_db_database_version" {
  description = "SQL DB Version"
  default     = "8.0.21"
}

variable "mysql_db_database_backup_retention_days" {
  description = "how long to keep MySQL backup"
  default     = "7"
}

variable "mysql_db_database_georedundant_backup" {
  description = "Geo-Redundant Backup Enabled"
  default     = "false"
}

variable "mysql_db_sql_sku" {
  description = "SQL SKU Size"
  default     = "GP_Standard_D2ds_v4"
}

variable "mysql_wordpress_database_name" {
  description = "WP DB name"
  default     = "wp-app-database"
}

/*
WordPress Settings
*/
variable "wordpress_admin_email" {
  description = "WP admin email"
}

variable "wordpress_admin_admin_user_name" {
  description = "WP admin user"
}

variable "wordpress_admin_admin_password" {
  description = "WP Admin password"
  sensitive   = true
}

variable "wordpress_default_site_title" {
  description = "WP Default title"
  default     = "WordPress On Azure App services"
}

variable "wordpress_locale_code" {
  description = "WP Locale Code"
  default     = "en_US"
}
variable "wordpress_container_linux_fx_version" {
  description = "WP Container Image version"
  default     = "appsvc/wordpress-debian-php"
}


variable "wordpress_container_start_time_limit" {
  description = "WP container start time limit"
  default     = "900"
}

variable "wordpress_setup_phpadmin" {
  description = "WP Setup PHP admin for new installs"
  default     = "true"
}

/*
Private DNS Settings
*/

variable "private_dns_zone_name_for_db" {
  description = "Private DNS Zone for Database"
  default     = "wp-appsvc-privatelink.mysql.database.azure.com"
}


/*
CDN Settings
*/
variable "cdn_endpoint_name" {
  description = "CDN Endpoint Name"
  default     = "wp-appsvc-endpoint"
}

variable "cdn_profile_name" {
  description = "CDN Profile"
  default     = "wp-appsvc-cdnprofile"
}

variable "cdn_type" {
  description = "CDN Profile"
  default     = "Standard_Microsoft" #Only allow Standard Microsoft
}


/*
Azure Front Door Settings
*/
variable "afd_profile_name" {
  description = "Azure Front Door Profile Name"
  default     = ""
}

variable "afd_endpoint_name" {
  description = "The name which should be used for this Front Door Endpoint"
  default     = "wp-appsvc-afdEndPoint"
}

variable "enable_afd_endpoint" {
  description = "Front Door Endpoint is enabled?"
  default     = true
}

variable "afd_origingroup_name" {
  description = "Front Door OriginGroup Name"
  default     = "wp-appsvc-afdOriginGroup"
}

variable "afd_origins_name" {
  description = "Front Door Origin Name"
  default     = "wp-appsvc-afdOrigins"
}

variable "afd_ruleset_name" {
  description = "Frontdoor Default Ruleset"
  default     = "wpappsvcruleset"
}