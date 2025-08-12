/*
SUMMARY:      Deploys a WordPress site hosted on Azure AppServices
DESCRIPTION:  Deploys a fully functional Wordpress site hosted on an Azure App service with a MySQL Flexible server back end with a CDN front end. 
              Approx. time to deploy 12 minutes - with AFD and Storage account.
REFERENCE:    https://techcommunity.microsoft.com/t5/apps-on-azure-blog/a-lowered-cost-and-more-performant-wordpress-on-azure-appservice/ba-p/3647860
              https://github.com/Azure/wordpress-linux-appservice/blob/main/WordPress/wordpress_migration_linux_appservices.md
              https://github.com/Azure/wordpress-linux-appService
AUTHOR/S:     aaron.saikovski@microsoft.com
VERSION:      1.2.1

VERSION HISTORY:
  1.0.0 - Initial version release
  1.1.0 - Added storage account to host content external to WordPress instance, tags and param switches
  1.2.0 - Added Azure Front Door and CDN modules
  1.2.1 - Minor AFD dependency fixes and web app parameter changes. updated readme.md
*/

// ================ //
// Input Parameters //
// ================ //

/*
Location
*/
param location string = resourceGroup().location

/*
Tags
*/
param tags object = {
  AppProfile: 'Wordpress'
}

/*
App Service Parameters
*/
param appServicePlanName string  = 'wp-appsvc-plan'

//Create a unique web app name
param appServiceWebAppPrefix string = 'wp-app-web'
param appServiceWebAppName string = '${appServiceWebAppPrefix}${uniqueString(resourceGroup().id)}'

param appSvcSku string = 'PremiumV2'
param appSvcSkuCode string ='P1v2'
param workerSizeId int = 3
param numberOfWorkers int = 1
param kind string = 'linux'
param reserved bool = true
param alwaysOn bool = true
param linuxFxVersion string = 'DOCKER|mcr.microsoft.com/appsvc/wordpress-debian-php:8.4'
param dockerRegistryUrl string = 'https://mcr.microsoft.com'
param storageSizeGB int = 128

/*
MySQL Parameters
*/
param storageIops int = 700
param storageAutoGrow string = 'Enabled'
param backupRetentionDays int = 7
param geoRedundantBackup string = 'Disabled'
param charset string = 'utf8'
param collation string = 'utf8_general_ci'
param vmName string = 'Standard_D2ds_v4'
param serverEdition string ='GeneralPurpose'
param databaseName string = 'wp-app-database'

@allowed([
  '5.7' 
  '8.0.21']
)
param databaseVersion string = '8.0.21'

param serverName string
param serverUsername string
@secure()
param serverPassword string


/*
WordPress App settings Parameters
*/
param wordpressTitle string = 'WordPress On Azure App services'
param wpLocaleCode string ='en_US'
param wordpressAdminEmail string
param wordpressUsername string

@secure()
param wordpressPassword string


/*
CDN Parameters
*/
param cdnProfileName string
param cdnEndpointName string

/*
Azure Front Door Policy vars
*/
param afdProfileName string = 'wp-appsvc-afdprofile'
param afdEndpointName string = 'wp-appsvc-afdEndPoint'
param afdOriginGroupName string = 'wp-appsvc-afdOriginGroup'
param afdOriginsName string = 'wp-appsvc-afdOrigins'
param afdRulesetName string = 'wpappsvcruleset'


/*
Networking Parameters
*/
param vnetName string = 'wp-app-vnet'
param subnetForApp string = 'wp-app-subnet'
param subnetForDb string = 'wp-db-subnet'
param privateDnsZoneNameForDb string = 'wp-appsvc-privatelink.mysql.database.azure.com'

param vnetAddress string = '10.0.0.0/16'
param subnetAddressForApp string = '10.0.0.0/24'
param subnetAddressForDb string = '10.0.1.0/24'

/*
WordPress App Storage Account
*/
param appServiceStorageAcctPrefix string = 'wpstg'
var appServiceStorageAcctName = '${appServiceStorageAcctPrefix}${uniqueString(resourceGroup().id)}'

param appServiceStorageBlobPrefix string = 'blobstg'
var appServiceStorageContainerName = '${appServiceStorageBlobPrefix}${uniqueString(resourceGroup().id)}'

@description('Storage Sku')
param appServiceStorageSku string = 'Standard_LRS'

/*
Conditional Deployment Params
*/
param deployAzureStorage bool = false
param deployCDN bool          = false //If true then FrontDoor MUST be false
param deployFrontDoor bool    = false //If true then CDN MUST be false

/*
Local Variables for storage account
*/
var blobStorageUrl     = deployAzureStorage ? '${appServiceStorageAccount.name}.blob.${environment().suffixes.storage}' : 'null'
var storageAccountKey  = deployAzureStorage ? '${listKeys(appServiceStorageAccount.id, appServiceStorageAccount.apiVersion).keys[0].value}' : 'null'
var storageAccountName = deployAzureStorage ? appServiceStorageAccount.name : 'null'


// =========== //
// Deployments //
// =========== //
@description('Wordpress Web App Storage Account')
resource appServiceStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = if (deployAzureStorage) {
  name: appServiceStorageAcctName 
  kind: 'StorageV2'
  location: location
  tags: tags

  sku: {
    name: appServiceStorageSku
  }

  properties: {
    allowCrossTenantReplication: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

@description('Wordpress Web App Storage Account Blob Container')
resource appServiceStorageContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = if (deployAzureStorage) {
  name: '${appServiceStorageAccount.name}/default/${appServiceStorageContainerName}'
}

@description('Wordpress Web App Settings')
resource appServiceWebApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceWebAppName
  location: location
  tags: tags
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'DOCKER_REGISTRY_SERVER_URL'
          value: dockerRegistryUrl
        }  
        {
          name: 'DATABASE_HOST'
          value: '${serverName}.mysql.database.azure.com'
        }
        {
          name: 'DATABASE_NAME'
          value: databaseName
        }
        {
          name: 'DATABASE_USERNAME'
          value: serverUsername
        }
        {
          name: 'DATABASE_PASSWORD'
          value: serverPassword
        }
        {
          name: 'WORDPRESS_ADMIN_EMAIL'
          value: wordpressAdminEmail
        }
        {
          name: 'WORDPRESS_ADMIN_USER'
          value: wordpressUsername
        }
        {
          name: 'WORDPRESS_ADMIN_PASSWORD'
          value: wordpressPassword
        }
        {
          name: 'WORDPRESS_TITLE'
          value: wordpressTitle
        }
        {
          name: 'WEBSITES_CONTAINER_START_TIME_LIMIT'
          value: '900'
        }
        {
          name: 'WORDPRESS_LOCALE_CODE'
          value: wpLocaleCode
        }
        {
          name: 'SETUP_PHPMYADMIN'
          value: 'true'
        }
        {
          name: 'CDN_ENABLED'
          value: '${deployCDN}'
        }
        {
          name: 'CDN_ENDPOINT'
          value: '${cdnEndpointName}.azureedge.net'
        }
        {
          name: 'BLOB_CONTAINER_NAME'
          value: appServiceStorageContainerName
        }
        {
          name: 'BLOB_STORAGE_ENABLED'
          value: '${deployAzureStorage}'
        }
        {
          name: 'BLOB_STORAGE_URL'
          value: blobStorageUrl
        }
        {
          name: 'STORAGE_ACCOUNT_KEY'
          value: storageAccountKey
        }
        {
          name: 'STORAGE_ACCOUNT_NAME'
          value: storageAccountName
        }
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: '${deployAzureStorage}'
        }
      ]
      connectionStrings: []
      linuxFxVersion: linuxFxVersion
      vnetRouteAllEnabled: true
    }
    serverFarmId:appServiceHostingPlan.id
    clientAffinityEnabled: false
  }
  dependsOn: [
    mySQLserver
    wordpressDatabase
  ]
}

@description('App service hostingplan')
resource appServiceHostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  kind: kind
  tags: tags
  properties: {
    targetWorkerCount:numberOfWorkers
    targetWorkerSizeId:workerSizeId
    reserved: reserved
  }
  sku: {
    tier: appSvcSku
    name: appSvcSkuCode
  }
  dependsOn: [
    mySQLserver
  ]
}

@description('MySQL Server - Flexible server')
resource mySQLserver 'Microsoft.DBforMySQL/flexibleServers@2021-05-01' = {
  location: location
  name: serverName
  tags: tags
  properties: {
    version: databaseVersion
    administratorLogin: serverUsername
    administratorLoginPassword: serverPassword
    storage: {
      storageSizeGB: storageSizeGB
      iops: storageIops
      autoGrow: storageAutoGrow
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    network: {
      privateDnsZoneResourceId: privateDnsZoneMySql.id
      delegatedSubnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetForDb)
    }
  }

  sku: {
    name: vmName
    tier: serverEdition
  }
  dependsOn: [
    privateDnsZoneMySqlVnetlink
  ]
}

@description('Wordpress DB name')
resource wordpressDatabase 'Microsoft.DBforMySQL/flexibleServers/databases@2021-05-01' = {
  parent: mySQLserver
  name: databaseName

  properties: {
    charset: charset
    collation: collation
  }
}

@description('Virtual network')
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  location: location
  name: vnetName
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddress
      ]
    }
    subnets: [
      {
        name: subnetForApp
        properties: {
          addressPrefix: subnetAddressForApp
          delegations: [
            {
              name: 'dlg-appService'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
      {
        name: subnetForDb
        properties: {
          addressPrefix: subnetAddressForDb
          delegations: [
            {
              name: 'dlg-database'
              properties: {
                serviceName: 'Microsoft.DBforMySQL/flexibleServers'
              }
            }
          ]
        }
      }
    ]
  }
 }

@description('Private DNS Zone for Database')
resource privateDnsZoneMySql 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneNameForDb
  location: 'global'
}

@description('Link DNS Zone to VNet')
resource privateDnsZoneMySqlVnetlink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneMySql
  name: '${privateDnsZoneNameForDb}-vnetlink'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: virtualNetwork.id
    }
    registrationEnabled: true
  }
}

@description('Configure the Web app to use the Subnet')
resource appServiceVNetConfig 'Microsoft.Web/sites/networkConfig@2022-03-01' = {
  parent: appServiceWebApp
  name: 'virtualNetwork'
  properties: {
    subnetResourceId: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnetForApp)
  }
  dependsOn: [
    privateDnsZoneMySqlVnetlink
  ]
}

@description('Web app configuration')
resource appServiceSiteConfig 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: appServiceWebApp
  name: 'web'
  properties: {
    alwaysOn: alwaysOn
  }
  dependsOn: [
    appServiceVNetConfig
  ]
}

@description('CDN Profile and Endpoint Module')
module cdnProfile './modules/cdn.bicep' = if (deployCDN) {
  name: cdnProfileName
  params:{
    tags: tags
    cdnProfileName:cdnProfileName
    cdnEndpointName:cdnEndpointName
    appServiceWebAppName:appServiceWebAppName
  }
  dependsOn: [
    mySQLserver
    appServiceWebApp
  ]
}

@description('Create Azure Front Door WAF Profile')
module afdProfile 'modules/afd.bicep' = if (deployFrontDoor) {
  name:afdProfileName
  params:{
    tags: tags
    afdProfileName:afdProfileName
    afdEndpointName:afdEndpointName
    afdOriginGroupName:afdOriginGroupName
    afdOriginsName:afdOriginsName
    afdRulesetName:afdRulesetName
    appServiceWebAppName:appServiceWebAppName
  }
  dependsOn: [
    mySQLserver
    appServiceWebApp
  ]
}

// ================  //
// Output Parameters //
// ================  //
@description('Default hostname of the app.')
output defaultHostname string = appServiceWebApp.properties.defaultHostName
