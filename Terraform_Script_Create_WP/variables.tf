variable "tags" {
  description = "resource tags"
  default     = {}
}

variable "resource_group_name" {
  description = "Resource Group"
  default     = "wordpress-appsvc-rg"
}

variable "rg_location" {
  description = "Location"
  default     = "West US"
}

variable "vnet_name" {
  description = "Virtual Network Name"
  default     = "wp-app-vnet"
}

variable "vnet_address_space" {
  description = "CIDR Block of the VNet"
  default     = "10.0.0.0/16"
}

variable "app_subnet" {
  description = "name of App Subnet"
  default     = "wp-app-subnet"
}

variable "app_subnet_cidr" {
  description = "cidr for App Subnet"
  default     = "10.0.0.0/24"
}

variable "db_subnet" {
  description = "name of db Subnet"
  default     = "wp-db-subnet"
}

variable "db_subnet_cidr" {
  description = "cidr for Db Subnet"
  default     = "10.0.1.0/24"
}

variable "appServicePlanName" {
  description = "App service plan name"
  default     = "wp-appsvc-plan"
}

variable "appServiceWebAppName" {
  description = "App service App name"
  default     = "wp-app-web"
}

variable "appSvcSkuCode" {
  description = "App service SKU"
  default     = "P1v2"
}


variable "numberOfWorkers" {
  description = "App service Workers"
  default     = 1
}

variable "alwaysOn" {
  description = "App service Always On"
  default     = true
}

variable "dockerRegistryUrl" {
  description = "Docker Registry URL"
  default     = "https://mcr.microsoft.com"
}

variable "serverEdition" {
  description = "DB Server Edition"
  default     = "GeneralPurpose"
}


variable "DBServerName" {
  description = "DB Servername"
  default     = "wp-app-dbserver"
}


variable "DBServerUsername" {
  description = "DB Server Username"
}

variable "serverPassword" {
  description = "DB Server Password"
  sensitive   = true
}

variable "databaseName" {
  description = "WP DB name"
  default     = "wp-app-database"
}


variable "wordpressAdminEmail" {
  description = "WP admin email"
  #default     = "wp-app-database"
}

variable "wordpressUsername" {
  description = "WP admin user"
}

variable "wordpressPassword" {
  description = "WP Admin password"
  sensitive   = true
}

variable "wordpressTitle" {
  description = "WP Default title"
  default     = "WordPress On Azure App services"
}

variable "wpLocaleCode" {
  description = "WP Locale Code"
  default     = "en_US"
}

variable "cdnEndpointName" {
  description = "CDN Endpoint Name"
  default     = "wp-appsvc-endpoint"
}

variable "linuxFxVersion" {
  description = "WP Container Image version"
  default     = "mcr.microsoft.com/appsvc/wordpress-alpine-php"
}


variable "privateDnsZoneNameForDb" {
  description = "Private DNS Zone for Database"
  default     = "wp-appsvc-privatelink.mysql.database.azure.com"
}


variable "MySQLSku" {
  description = "SQL SKU Size"
  default     = "GP_Standard_D2ds_v4"
}


variable "storageSizeGB" {
  description = "SQL DB Storage Size"
  default     = "128"
}

variable "storageIops" {
  description = "SQL DB Storage IOPS"
  default     = "700"
}

variable "storageAutoGrow" {
  description = "SQL DB Storage Autogrow"
  default     = "Enabled"
}

variable "databaseVersion" {
  description = "SQL DB Version"
  default     = "8.0.21"
}

variable "backupRetentionDays" {
  description = "how long to keep MySQL backup"
  default     = "7"
}

variable "geoRedundantBackup" {
  description = "Geo-Redundant Backup Enabled"
  default     = "false"
}


variable "cdnProfileName" {
  description = "CDN Profile"
  default     = "wp-appsvc-cdnprofile"
}

variable "cdnType" {
  description = "CDN Profile"
  default     = "Standard_Microsoft"
}
