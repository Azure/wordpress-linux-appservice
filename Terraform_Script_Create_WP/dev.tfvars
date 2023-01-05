/***********************************/
# DEV Variables
/***********************************/

##Password is not saved in here - you will be prompted for this for both the database server and the wordpress installation.

#Tags
tags = {
  AppProfile = "Wordpress"
}

#Conditional deployment flags
deployAzureStorage = false  //Deploy storage account for use with Wordpress
deployCDN          = false //If true then FrontDoor MUST be false
deployFrontDoor    = false  //If true then CDN MUST be false

#Resource Group
resource_group_name = "wordpress-appsvc-rg"

#Location - set all resources to RG location as default
rg_location = "Australia East"

#VNet Name
vnet_name = "wp-app-vnet"

#VNet CIDR Address Block
vnet_address_space = "10.0.0.0/16"

#App Subnet name
app_subnet = "wp-app-subnet"

#App Subnet CIDR
app_subnet_cidr = "10.0.0.0/24"

#DB Subnet name
db_subnet = "wp-db-subnet"

#DB Subnet CIDR
db_subnet_cidr = "10.0.1.0/24"

#App Service Plan Name
appServicePlanName = "wp-appsvc-plan"

#Web App Name prefix
app_service_web_app_prefix = "wp-app-web"


#App Svc SKU
appSvcSkuCode = "P1v2"

#DB ServerName
DBServerName = "wp-app-dbserver"

#DB Username
DBServerUsername = "wpdbuser"

#WP DB Name
databaseName = "wp-app-database"

#WP Admin email
wordpressAdminEmail = "someuser@somedomain.com"

#WP UserAdmin
wordpressUsername = "wpappuser"

#WP Title
wordpressTitle = "WordPress On Azure App services"

#WP Locale
wpLocaleCode = "en_US"

#Private DNS Zone Name for DB
privateDnsZoneNameForDb = "wp-appsvc-privatelink.mysql.database.azure.com"

#MYSQL SKU
MySQLSku = "GP_Standard_D2ds_v4"

#MYSQL Storage Size
storageSizeGB = "128"

#MySQL Storage IOPs
storageIops = "700"

#MYSQL Autogrow
storageAutoGrow = "Enabled"

#MYSql backup retention days
backupRetentionDays = "7"

#Enable MySQL Geo-Redundant Backup
geoRedundantBackup = "false"

#CDN Endpoint Name
cdnEndpointName = "wp-appsvc-endpoint2"

#CDN Profile Name
cdnProfileName = "wp-appsvc-cdnprofile"


/*
Azure Front Door Policy vars
*/
afd_profile_name     = "wp-appsvc-afdprofile"
afd_endpoint_name    = "wp-appsvc-afdEndPoint"
afd_origingroup_name = "wp-appsvc-afdOriginGroup"
afd_origins_name     = "wp-appsvc-afdOrigins"
afd_ruleset_name     = "wpappsvcruleset"