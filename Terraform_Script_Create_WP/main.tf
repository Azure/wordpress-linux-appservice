/*
SUMMARY:      Deploys a WordPress site hosted on Azure AppServices using Terraform
DESCRIPTION:  Deploys a fully functional Wordpress site hosted on an Azure App service with a MySQL Flexible server back end with a CDN front end. - Approx. time to deploy 9 minutes.
REFERENCE:    https://techcommunity.microsoft.com/t5/apps-on-azure-blog/a-lowered-cost-and-more-performant-wordpress-on-azure-appservice/ba-p/3647860
              https://github.com/Azure/wordpress-linux-appservice/blob/main/WordPress/wordpress_migration_linux_appservices.md
              https://github.com/Azure/wordpress-linux-appService
AUTHOR/S:     aaron.saikovski@microsoft.com
VERSION: 1.1.0

VERSION HISTORY:
  1.0.0 - Initial version release
  1.1.0 - Added storage account to host content external to WordPress instance, added CDN and Azure Front door modules - conditional deployments
*/

#Resource Group
resource "azurerm_resource_group" "rsg" {
  name     = var.resource_group_name
  location = var.rg_location
  tags     = var.tags
}

/*
WordPress App Storage Account and default container
*/
module "appservicestorageaccount" {
  # Deploy conditionally based on Feature Flag variable
  count               = var.deployAzureStorage == true ? 1 : 0
  source              = "./modules/storage"
  location            = azurerm_resource_group.rsg.location
  resource_group_name = azurerm_resource_group.rsg.name
  tags                = var.tags
}

/*
Local Variables for storage account - conditionally set if feature flags enabled
*/
locals {
  storageAccountName       = var.deployAzureStorage == true ? module.appservicestorageaccount[0].name : ""
  blobStorageUrl           = var.deployAzureStorage == true ? module.appservicestorageaccount[0].primary_blob_endpoint : ""
  storageAccountKey        = var.deployAzureStorage == true ? module.appservicestorageaccount[0].primary_access_key : ""
  storageBlobContainerName = var.deployAzureStorage == true ? module.appservicestorageaccount[0].storage_blob_container_name : ""
}

# Generate a random integer to create a globally unique name for the web app name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

//Generate a unique web app name
locals {
  web_app_name = "${var.app_service_web_app_prefix}-${random_integer.ri.result}"
}


#App Service Plan
resource "azurerm_service_plan" "app_svc_plan" {
  location            = azurerm_resource_group.rsg.location
  name                = var.appServicePlanName
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.rsg.name
  sku_name            = var.appSvcSkuCode
  worker_count        = var.numberOfWorkers
  depends_on = [
    azurerm_mysql_flexible_server.mysql_db_server
  ]
}

# Web app
resource "azurerm_linux_web_app" "wp_web_app" {
  app_settings = {
    DOCKER_REGISTRY_SERVER_URL          = var.dockerRegistryUrl
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    DATABASE_HOST                       = "${var.DBServerName}.mysql.database.azure.com"
    DATABASE_USERNAME                   = var.DBServerUsername
    DATABASE_NAME                       = var.databaseName
    DATABASE_PASSWORD                   = var.serverPassword
    WORDPRESS_ADMIN_EMAIL               = var.wordpressAdminEmail
    WORDPRESS_ADMIN_USER                = var.wordpressUsername
    WORDPRESS_ADMIN_PASSWORD            = var.wordpressPassword
    WORDPRESS_TITLE                     = var.wordpressTitle
    WEBSITES_CONTAINER_START_TIME_LIMIT = "900"
    WORDPRESS_LOCALE_CODE               = var.wpLocaleCode
    SETUP_PHPMYADMIN                    = "true"
    CDN_ENABLED                         = var.deployCDN ? "true" : "false"
    CDN_ENDPOINT                        = "${var.cdnEndpointName}.azureedge.net"
    BLOB_STORAGE_ENABLED                = var.deployAzureStorage ? "true" : "false"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = var.deployAzureStorage ? "true" : "false"
    STORAGE_ACCOUNT_NAME                = local.storageAccountName
    BLOB_STORAGE_URL                    = local.blobStorageUrl
    STORAGE_ACCOUNT_KEY                 = local.storageAccountKey
    BLOB_CONTAINER_NAME                 = local.storageBlobContainerName
  }

  location                  = azurerm_resource_group.rsg.location
  name                      = local.web_app_name 
  resource_group_name       = azurerm_resource_group.rsg.name
  service_plan_id           = azurerm_service_plan.app_svc_plan.id
  virtual_network_subnet_id = azurerm_subnet.app-subnet.id
  client_affinity_enabled   = false
  site_config {
    ftps_state = "AllAllowed"
    always_on  = var.alwaysOn

    vnet_route_all_enabled = true
    application_stack {
      docker_image     = var.linuxFxVersion
      docker_image_tag = "latest"
    }
  }
  depends_on = [
    azurerm_mysql_flexible_server.mysql_db_server,
    azurerm_mysql_flexible_database.wordpressDatabase
  ]
}

#VNet
resource "azurerm_virtual_network" "vnet" {
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.rsg.location
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rsg.name
  depends_on = [
    azurerm_resource_group.rsg
  ]
}

#App Subnet
resource "azurerm_subnet" "app-subnet" {
  name                 = var.app_subnet
  address_prefixes     = [var.app_subnet_cidr]
  resource_group_name  = azurerm_resource_group.rsg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "dlg-appService"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

#DB Subnet
resource "azurerm_subnet" "db-subnet" {
  name                 = var.db_subnet
  address_prefixes     = [var.db_subnet_cidr]
  resource_group_name  = azurerm_resource_group.rsg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  delegation {
    name = "dlg-database"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.DBforMySQL/flexibleServers"
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

#Private DNS Zone for DB
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.privateDnsZoneNameForDb
  resource_group_name = azurerm_resource_group.rsg.name
  depends_on = [
    azurerm_resource_group.rsg
  ]
}

#Link DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "privateDnsZoneMySqlVnetlink" {
  name                  = "${var.privateDnsZoneNameForDb}-vnetlink"
  resource_group_name   = azurerm_resource_group.rsg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  registration_enabled  = true
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone,
    azurerm_virtual_network.vnet
  ]
}


#MySQL Server - Flexible server
resource "azurerm_mysql_flexible_server" "mysql_db_server" {
  delegated_subnet_id          = azurerm_subnet.db-subnet.id
  private_dns_zone_id          = azurerm_private_dns_zone.private_dns_zone.id
  location                     = azurerm_resource_group.rsg.location
  name                         = var.DBServerName
  resource_group_name          = azurerm_resource_group.rsg.name
  sku_name                     = var.MySQLSku
  version                      = var.databaseVersion
  backup_retention_days        = var.backupRetentionDays
  geo_redundant_backup_enabled = var.geoRedundantBackup
  administrator_login          = var.DBServerUsername
  administrator_password       = var.serverPassword
  tags                         = var.tags
  zone                         = 1
  storage {
    size_gb = var.storageSizeGB
    iops    = var.storageIops
  }
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.privateDnsZoneMySqlVnetlink
  ]
}

# Wordpress DB name
resource "azurerm_mysql_flexible_database" "wordpressDatabase" {
  name                = var.databaseName
  resource_group_name = azurerm_resource_group.rsg.name
  server_name         = azurerm_mysql_flexible_server.mysql_db_server.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
  depends_on = [
    azurerm_mysql_flexible_server.mysql_db_server
  ]
}



/*
#CDN Profile - module - conditional deployment
*/
module "cdnProfile" {
  # Deploy conditionally based on Feature Flag variable
  count                  = var.deployCDN == true ? 1 : 0
  source                 = "./modules/cdn"
  cdn_profile_depends_on = [azurerm_mysql_flexible_server.mysql_db_server, azurerm_linux_web_app.wp_web_app]
  resource_group_name    = azurerm_resource_group.rsg.name
  sku                    = var.cdnType
  origin_host_header     = "${local.web_app_name}.azurewebsites.net" 
  tags                   = var.tags
  cdn_profile_name       = var.cdnProfileName
  cdn_endpoint_name      = var.cdnEndpointName

  origin = {
    host_name  = "${local.web_app_name}.azurewebsites.net" 
    name       = "${local.web_app_name}-azurewebsites.net" 
    http_port  = 80
    https_port = 443
  }
}

/*
#Azure Front Door - module - conditional deployment
*/
module "afdProfile" {
  # Deploy conditionally based on Feature Flag variable
  count                  = var.deployFrontDoor == true ? 1 : 0
  source                 = "./modules/afd"
  afd_profile_depends_on = [azurerm_mysql_flexible_server.mysql_db_server, azurerm_linux_web_app.wp_web_app]
  resource_group_name    = azurerm_resource_group.rsg.name
  origin_host_header     = "${local.web_app_name}.azurewebsites.net" 
  tags                   = var.tags
  afd_profile_name       = var.afd_profile_name
  afd_endpoint_name      = var.afd_endpoint_name
  afd_origingroup_name   = var.afd_origingroup_name
  afd_origins_name       = var.afd_origins_name
  afd_ruleset_name       = var.afd_ruleset_name
}