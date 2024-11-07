/*
SUMMARY: Module to create an Azure CDN
DESCRIPTION: The following components will be required parameters in this deployment
   Microsoft.Cdn/profiles
   Microsoft.Cdn/profiles/endpoints
AUTHOR/S: asaikovski
VERSION: 1.0.0
*/

@description('CDN profile name')
param cdnProfileName string

@description('CDN endpoint name')
param cdnEndpointName string

@description('Origin timeout period')
param originResponseTimeoutSeconds int = 60 


@description('Web app to host as origin server')
param appServiceWebAppName string 

@description('Allowed CDN SKUs')
@allowed([
  'Standard_Microsoft' 
  ]
)
param cdnType string = 'Standard_Microsoft'

@description('Tags')
param tags object = {}


@description('CDN Profile')
resource cdnProfile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: cdnProfileName
  location: 'Global'
  sku: {
    name: cdnType
  }
  tags: tags
  properties: {
    originResponseTimeoutSeconds: originResponseTimeoutSeconds
  }
}

@description('CDN Endpoint Config')
resource cdnProfileEndPoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' =  {
  parent: cdnProfile
  name: cdnEndpointName
  location: 'Global'
  properties: {
    isHttpAllowed: true
    isHttpsAllowed: true
    originHostHeader: '${appServiceWebAppName}.azurewebsites.net'
    origins: [
      {
        name: '${appServiceWebAppName}-azurewebsites-net'
        properties: {
          hostName: '${appServiceWebAppName}.azurewebsites.net'
          httpPort: 80
          httpsPort: 443
          originHostHeader: '${appServiceWebAppName}.azurewebsites.net'
          priority: 1
          weight: 1000
          enabled: true
        }
      }
    ]
    isCompressionEnabled: true
    contentTypesToCompress: [
      'application/eot'
      'application/font'
      'application/font-sfnt'
      'application/javascript'
      'application/json'
      'application/opentype'
      'application/otf'
      'application/pkcs7-mime'
      'application/truetype'
      'application/ttf'
      'application/vnd.ms-fontobject'
      'application/xhtml+xml'
      'application/xml'
      'application/xml+rss'
      'application/x-font-opentype'
      'application/x-font-truetype'
      'application/x-font-ttf'
      'application/x-httpd-cgi'
      'application/x-javascript'
      'application/x-mpegurl'
      'application/x-opentype'
      'application/x-otf'
      'application/x-perl'
      'application/x-ttf'
      'font/eot'
      'font/ttf'
      'font/otf'
      'font/opentype'
      'image/svg+xml'
      'text/css'
      'text/csv'
      'text/html'
      'text/javascript'
      'text/js'
      'text/plain'
      'text/richtext'
      'text/tab-separated-values'
      'text/xml'
      'text/x-script'
      'text/x-component'
      'text/x-java-source'
    ]
  }
}

@description('CDN Profile Endpoint ID')
output cdnProfileId string = cdnProfileEndPoint.id

@description('CDN  Endpoint ID')
output cdnProfileEndPointId string = cdnProfileEndPoint.id

@description('CDN Profile Host Name')
output cdnProfileEndPointHostName string = cdnProfileEndPoint.properties.hostName
