# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_profile
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_endpoint

#Create a CDN Profile
resource "azurerm_cdn_profile" "cdn_profile" {
  name                = var.cdn_profile_name
  location            = "global"
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
  depends_on          = [var.cdn_profile_depends_on]
}


#Create a CDN Endpoint
resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  depends_on = [azurerm_cdn_profile.cdn_profile]
  location               = "global"
  name                   = var.cdn_endpoint_name
  profile_name           = azurerm_cdn_profile.cdn_profile.name  
  resource_group_name    = var.resource_group_name
  is_compression_enabled = var.is_compression_enabled
  origin_host_header     = var.origin_host_header
  is_http_allowed        = true
  is_https_allowed       = true

 origin {
    name       = var.origin.name
    host_name  = var.origin.host_name
    http_port  = var.origin.http_port
    https_port = var.origin.https_port
  }

  content_types_to_compress = [
    "application/eot",
    "application/font",
    "application/font-sfnt",
    "application/javascript",
    "application/json",
    "application/opentype",
    "application/otf",
    "application/pkcs7-mime",
    "application/truetype",
    "application/ttf",
    "application/vnd.ms-fontobject",
    "application/xhtml+xml",
    "application/xml",
    "application/xml+rss",
    "application/x-font-opentype",
    "application/x-font-truetype",
    "application/x-font-ttf",
    "application/x-httpd-cgi",
    "application/x-javascript",
    "application/x-mpegurl",
    "application/x-opentype",
    "application/x-otf",
    "application/x-perl",
    "application/x-ttf",
    "font/eot",
    "font/ttf",
    "font/otf",
    "font/opentype",
    "image/svg+xml",
    "text/css",
    "text/csv",
    "text/html",
    "text/javascript",
    "text/js",
    "text/plain",
    "text/richtext",
    "text/tab-separated-values",
    "text/xml",
    "text/x-script",
    "text/x-component",
    "text/x-java-source"
  ]
}