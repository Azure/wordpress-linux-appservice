/*
SUMMARY: Module to create an Azure Front Door resource
DESCRIPTION: The following components will be required parameters in this deployment
   Microsoft.Cdn/profiles
   Microsoft.Cdn/profiles/afdEndpoints
   Microsoft.Cdn/profiles/afdendpoints/routes
   Microsoft.Cdn/profiles/originGroups
   Microsoft.Cdn/profiles/originGroups/origins
   Microsoft.Cdn/profiles/rulesets
   Microsoft.Cdn/profiles/rulesets/rules

AUTHOR/S:     aaron.saikovski@microsoft.com
VERSION:      1.0.1

VERSION HISTORY:
  1.0.0 - Initial version release
  1.0.1 - Fixed minor dependency bugs when deploying
*/

@description('Name of AFD Profile')
param afdProfileName string 

@description('AFD Endpoint Name')
param afdEndpointName string

@description('AFD Endpoint State')
@allowed([
  'Enabled'
  'Disabled'
])
param enableAfdEndpoint string = 'Enabled'

@description('AFD Default route name')
param afdDefaultRouteName string ='default-route'

@description('AFD Origin Group Name')
param afdOriginGroupName string

@description('AFD Origins Name')
param afdOriginsName string

@description('Origin Host')
param appServiceWebAppName string

@allowed([
  'Premium_AzureFrontDoor'
  'Standard_AzureFrontDoor'
])
@description('Name of Azure CDN SKU')
param skuName string = 'Standard_AzureFrontDoor'

@description('Tags')
param tags object = {}

@description('Enabled State')
@allowed([
  'Enabled'
  'Disabled'
])
param originEnabledState string = 'Enabled'

@description('Origin timeout period')
param originResponseTimeoutSeconds int = 60 

@description('AFD Ruleset name')
param afdRulesetName string



@description('Create AFD Profile')
resource afdProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: afdProfileName
  location: 'Global'
  tags: tags
  sku: {
    name: skuName
  }
  properties: {
    originResponseTimeoutSeconds: originResponseTimeoutSeconds
  }
}

@description('Create AFD Endpoint')
resource afdEndpoint 'Microsoft.Cdn/profiles/afdEndpoints@2021-06-01' = {
  parent: afdProfile
  name: afdEndpointName
  location: 'Global'
  properties: {
    enabledState: enableAfdEndpoint
  }
  dependsOn:[
    afdProfile
  ]
}

@description('AFD Endpoint Route')
resource afdDefaultRoute 'Microsoft.Cdn/profiles/afdendpoints/routes@2022-05-01-preview' = {
  parent: afdEndpoint
  name: afdDefaultRouteName 
  properties: {
    customDomains: []
    originGroup: {
      id: afdOriginGroup.id
    }
    ruleSets: [
      {
        id: afdRuleset.id
      }
    ]
    supportedProtocols: [
      'Http'
      'Https'
    ]
    patternsToMatch: [
      '/*'
    ]
    forwardingProtocol: 'MatchRequest'
    linkToDefaultDomain: 'Enabled'
    httpsRedirect: 'Enabled'
    enabledState: 'Enabled'
  }
  dependsOn:[
    afdProfile
    afdEndpoint
  ]
}

@description('Origin Groups')
resource afdOriginGroup 'Microsoft.Cdn/profiles/originGroups@2021-06-01' = {
  parent: afdProfile
  name: afdOriginGroupName
  properties: {
    loadBalancingSettings: {
      sampleSize: 4
      successfulSamplesRequired: 3
      additionalLatencyInMilliseconds: 50
    }
    healthProbeSettings: {
      probePath: '/'
      probeRequestType: 'GET'
      probeProtocol: 'Https'
      probeIntervalInSeconds: 100
    }
    sessionAffinityState: 'Disabled'
  }
  dependsOn:[
    afdProfile
  ]
}

@description('List of origin and mapping to Origin Groups')
resource afdOrigins 'Microsoft.Cdn/profiles/originGroups/origins@2021-06-01' = {
  parent: afdOriginGroup
  name: afdOriginsName
  properties: {
    hostName: '${appServiceWebAppName}.azurewebsites.net'
    httpPort: 80
    httpsPort: 443
    originHostHeader: '${appServiceWebAppName}.azurewebsites.net'
    priority: 1
    weight: 1000
    enabledState: originEnabledState
    enforceCertificateNameCheck: true
  }
  dependsOn:[
    afdOriginGroup
  ]
}

resource afdRuleset 'Microsoft.Cdn/profiles/rulesets@2022-05-01-preview' = {
  parent: afdProfile
  name: afdRulesetName
  dependsOn:[
    afdProfile
    afdEndpoint
  ]
}

@description('Default Rule for Ruleset')
resource afdRulesetDefault 'Microsoft.Cdn/profiles/rulesets/rules@2022-05-01-preview' = {
  parent: afdRuleset
  name: 'defaultrule'
  properties: {
    order: 1
    conditions: [
      {
        name: 'UrlPath'
        parameters: {
          typeName: 'DeliveryRuleUrlPathMatchConditionParameters'
          operator: 'BeginsWith'
          negateCondition: false
          matchValues: [
            'wp-content/uploads/'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'RouteConfigurationOverride'
        parameters: {
          typeName: 'DeliveryRuleRouteConfigurationOverrideActionParameters'
          cacheConfiguration: {
            isCompressionEnabled: 'Enabled'
            queryStringCachingBehavior: 'UseQueryString'
            cacheBehavior: 'OverrideAlways'
            cacheDuration: '3.00:00:00'
          }
          originGroupOverride: {
            originGroup: {
              id: afdOriginGroup.id
            }
            forwardingProtocol: 'MatchRequest'
          }
        }
      }
    ]
    matchProcessingBehavior: 'Stop'
  }
  dependsOn:[
    afdRuleset
  ]
}

@description('CacheStaticFiles Ruleset')
resource afdRulesetCacheStaticFiles 'Microsoft.Cdn/profiles/rulesets/rules@2022-05-01-preview' = {
  parent: afdRuleset
  name: 'CacheStaticFiles'
  properties: {
    order: 2
    conditions: [
      {
        name: 'UrlPath'
        parameters: {
          typeName: 'DeliveryRuleUrlPathMatchConditionParameters'
          operator: 'BeginsWith'
          negateCondition: false
          matchValues: [
            'wp-includes/'
            'wp-content/themes/'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
      {
        name: 'UrlFileExtension'
        parameters: {
          typeName: 'DeliveryRuleUrlFileExtensionMatchConditionParameters'
          operator: 'Equal'
          negateCondition: false
          matchValues: [
            'css'
            'js'
            'gif'
            'png'
            'jpg'
            'ico'
            'ttf'
            'otf'
            'woff'
            'woff2'
          ]
          transforms: [
            'Lowercase'
          ]
        }
      }
    ]
    actions: [
      {
        name: 'RouteConfigurationOverride'
        parameters: {
          typeName: 'DeliveryRuleRouteConfigurationOverrideActionParameters'
          cacheConfiguration: {
            isCompressionEnabled: 'Enabled'
            queryStringCachingBehavior: 'UseQueryString'
            cacheBehavior: 'OverrideAlways'
            cacheDuration: '3.00:00:00'
          }
        }
      }
    ]
    matchProcessingBehavior: 'Stop'
  }
  dependsOn:[
    afdRulesetDefault
  ]
}

@description('Profile Id')
output id string = afdProfile.id

@description('Endpoint Hostname')
output hostname string = afdEndpoint.properties.hostName
