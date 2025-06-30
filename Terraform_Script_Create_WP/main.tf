/*
SUMMARY:      Deploys a WordPress site hosted on Azure AppServices using Terraform
DESCRIPTION:  Deploys a fully functional Wordpress site hosted on an Azure App service with a MySQL Flexible server back end with a CDN front end. - Approx. time to deploy 9 minutes.
REFERENCE:    https://techcommunity.microsoft.com/t5/apps-on-azure-blog/a-lowered-cost-and-more-performant-wordpress-on-azure-appservice/ba-p/3647860
              https://github.com/Azure/wordpress-linux-appservice/blob/main/WordPress/wordpress_migration_linux_appservices.md
              https://github.com/Azure/wordpress-linux-appService
AUTHOR/S:     aaron.saikovski@microsoft.com
VERSION: 1.1.1

VERSION HISTORY:
  1.0.0 - Initial version release
  1.1.0 - Added storage account to host content external to WordPress instance, added CDN and Azure Front door modules - conditional deployments
  1.1.1 - Refactored variables, modules and resource naming to be in line with Terraform best practices - ref: https://www.terraform-best-practices.com/naming
*/

# Generate a random integer to create a globally unique name for the web app name
resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

// ================ //
// Local Variables  //
// ================ //
locals {

  //Wordpress Storage Account name derived from deployed storage account
  storage_account_name = var.deploy_azure_storage_account == true ? module.appservice_storage_account[0].name : ""

  //Wordpress Blob Storage url name derived from deployed storage account
  blob_storage_url = var.deploy_azure_storage_account == true ? module.appservice_storage_account[0].primary_blob_endpoint : ""

  //Wordpress Storage Account key derived from deployed storage account
  storage_account_key = var.deploy_azure_storage_account == true ? module.appservice_storage_account[0].primary_access_key : ""

  //Wordpress Storage Account blob container derived from deployed storage account
  storage_blob_container_name = var.deploy_azure_storage_account == true ? module.appservice_storage_account[0].storage_blob_container_name : ""

  //Generates a globally unique web app name using the supplied name prefix input
  web_app_name = "${var.app_service_web_app_prefix}-${random_integer.ri.result}"
}


// =========== //
// Deployments //
// =========== //

#Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = var.tags
}

/*
WordPress App Storage Account and default container
*/
module "appservice_storage_account" {
  # Deploy conditionally based on Feature Flag variable
  count               = var.deploy_azure_storage_account == true ? 1 : 0
  source              = "./modules/storage"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  tags                = var.tags
}

#App Service Plan
resource "azurerm_service_plan" "app_service_hosting_plan" {
  location            = azurerm_resource_group.resource_group.location
  name                = var.app_service_hosting_plan_name
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.resource_group.name
  sku_name            = var.app_service_hosting_plan_sku
  worker_count        = var.app_service_workers
  depends_on = [
    azurerm_mysql_flexible_server.mysql_db_server
  ]
}

# Web app
resource "azurerm_linux_web_app" "wordpress_web_app" {
  app_settings = {
    DATABASE_HOST                       = "${var.mysql_server_name}.mysql.database.azure.com"
    DATABASE_USERNAME                   = var.mysql_server_username
    DATABASE_NAME                       = var.mysql_wordpress_database_name
    DATABASE_PASSWORD                   = var.mysql_server_password
    WORDPRESS_ADMIN_EMAIL               = var.wordpress_admin_email
    WORDPRESS_ADMIN_USER                = var.wordpress_admin_admin_user_name
    WORDPRESS_ADMIN_PASSWORD            = var.wordpress_admin_admin_password
    WORDPRESS_TITLE                     = var.wordpress_default_site_title
    WEBSITES_CONTAINER_START_TIME_LIMIT = var.wordpress_container_start_time_limit
    WORDPRESS_LOCALE_CODE               = var.wordpress_locale_code
    SETUP_PHPMYADMIN                    = var.wordpress_setup_phpadmin
    CDN_ENABLED                         = var.deploy_azure_cdn ? "true" : "false"
    CDN_ENDPOINT                        = "${var.cdn_endpoint_name}.azureedge.net"
    BLOB_STORAGE_ENABLED                = var.deploy_azure_storage_account ? "true" : "false"
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = var.deploy_azure_storage_account ? "true" : "false"
    STORAGE_ACCOUNT_NAME                = local.storage_account_name
    BLOB_STORAGE_URL                    = local.blob_storage_url
    STORAGE_ACCOUNT_KEY                 = local.storage_account_key
    BLOB_CONTAINER_NAME                 = local.storage_blob_container_name
  }

  location                  = azurerm_resource_group.resource_group.location
  name                      = local.web_app_name
  resource_group_name       = azurerm_resource_group.resource_group.name
  service_plan_id           = azurerm_service_plan.app_service_hosting_plan.id
  virtual_network_subnet_id = azurerm_subnet.application_subnet.id
  client_affinity_enabled   = false

  site_config {
    ftps_state             = "AllAllowed"
    always_on              = var.app_service_alwayson
    vnet_route_all_enabled = true

    application_stack {
      docker_image = "${var.app_service_docker_registry_url}/${var.wordpress_container_linux_fx_version}"
      docker_image_tag = "8.2"
    }
  }




  depends_on = [
    azurerm_mysql_flexible_server.mysql_db_server,
    azurerm_mysql_flexible_database.wordpress_mysql_database
  ]

}

#VNet
resource "azurerm_virtual_network" "virtual_network" {
  name                = var.virtual_network_name
  address_space       = [var.virtual_network_address_space]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  depends_on = [
    azurerm_resource_group.resource_group
  ]
}

#App Subnet
resource "azurerm_subnet" "application_subnet" {
  name                 = var.virtual_network_app_subnet_name
  address_prefixes     = [var.virtual_network_app_subnet_cidr]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  delegation {
    name = "delegation-appService"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      name    = "Microsoft.Web/serverFarms"
    }
  }
  depends_on = [
    azurerm_virtual_network.virtual_network
  ]
}

#DB Subnet
resource "azurerm_subnet" "database_subnet" {
  name                 = var.virtual_network_db_subnet_name
  address_prefixes     = [var.virtual_network_db_subnet_cidr]
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  delegation {
    name = "delegation-database"
    service_delegation {
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
      name    = "Microsoft.DBforMySQL/flexibleServers"
    }
  }
  depends_on = [
    azurerm_virtual_network.virtual_network
  ]
}

#Private DNS Zone for DB
resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = var.private_dns_zone_name_for_db
  resource_group_name = azurerm_resource_group.resource_group.name
  depends_on = [
    azurerm_resource_group.resource_group
  ]
}

#Link DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_mysql_vnet_link" {
  name                  = "${var.private_dns_zone_name_for_db}-vnetlink"
  resource_group_name   = azurerm_resource_group.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = azurerm_virtual_network.virtual_network.id
  registration_enabled  = true
  depends_on = [
    azurerm_private_dns_zone.private_dns_zone,
    azurerm_virtual_network.virtual_network
  ]
}

#MySQL Server - Flexible server
resource "azurerm_mysql_flexible_server" "mysql_db_server" {
  name                         = var.mysql_server_name
  delegated_subnet_id          = azurerm_subnet.database_subnet.id
  private_dns_zone_id          = azurerm_private_dns_zone.private_dns_zone.id
  location                     = azurerm_resource_group.resource_group.location
  resource_group_name          = azurerm_resource_group.resource_group.name
  sku_name                     = var.mysql_db_sql_sku
  version                      = var.mysql_db_database_version
  backup_retention_days        = var.mysql_db_database_backup_retention_days
  geo_redundant_backup_enabled = var.mysql_db_database_georedundant_backup
  administrator_login          = var.mysql_server_username
  administrator_password       = var.mysql_server_password
  tags                         = var.tags
  //zone                         = 1
  storage {
    size_gb = var.mysql_db_storage_size_gb
    iops    = var.mysql_db_storage_iops
  }
  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.private_dns_zone_mysql_vnet_link
  ]
}

# Wordpress DB name
resource "azurerm_mysql_flexible_database" "wordpress_mysql_database" {
  name                = var.mysql_wordpress_database_name
  resource_group_name = azurerm_resource_group.resource_group.name
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
module "cdn_profile" {
  # Deploy conditionally based on Feature Flag variable
  count                  = var.deploy_azure_cdn == true ? 1 : 0
  source                 = "./modules/cdn"
  cdn_profile_depends_on = [azurerm_mysql_flexible_server.mysql_db_server, azurerm_linux_web_app.wordpress_web_app]
  resource_group_name    = azurerm_resource_group.resource_group.name
  sku                    = var.cdn_type
  origin_host_header     = "${local.web_app_name}.azurewebsites.net"
  tags                   = var.tags
  cdn_profile_name       = var.cdn_profile_name
  cdn_endpoint_name      = var.cdn_endpoint_name

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
module "afd_profile" {
  # Deploy conditionally based on Feature Flag variable
  count                  = var.deploy_azure_frontdoor == true ? 1 : 0
  source                 = "./modules/afd"
  afd_profile_depends_on = [azurerm_mysql_flexible_server.mysql_db_server, azurerm_linux_web_app.wordpress_web_app]
  resource_group_name    = azurerm_resource_group.resource_group.name
  origin_host_header     = "${local.web_app_name}.azurewebsites.net"
  tags                   = var.tags
  afd_profile_name       = var.afd_profile_name
  afd_endpoint_name      = var.afd_endpoint_name
  afd_origingroup_name   = var.afd_origingroup_name
  afd_origins_name       = var.afd_origins_name
  afd_ruleset_name       = var.afd_ruleset_name
}
