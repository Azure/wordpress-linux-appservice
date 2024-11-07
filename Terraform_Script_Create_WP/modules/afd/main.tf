# See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_profile
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_endpoint
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin_group
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_origin
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule_set
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_route
# and https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cdn_frontdoor_rule

#Create a AFD Profile
resource "azurerm_cdn_frontdoor_profile" "afd_profile" {
  name                = var.afd_profile_name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name 
  tags                = var.tags
  depends_on          = [var.afd_profile_depends_on]
}

#Create the AFD endpoint
resource "azurerm_cdn_frontdoor_endpoint" "afd_endpoint" {
  name                     = var.afd_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
  tags                     = var.tags
  enabled                  = var.enable_afd_endpoint
}

#Create the AFD Origin group
resource "azurerm_cdn_frontdoor_origin_group" "afd_origin_group" {
  name                     = var.afd_origingroup_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
  session_affinity_enabled = false

  load_balancing {
    additional_latency_in_milliseconds = 50
    sample_size                        = 4
    successful_samples_required        = 3
  }
   health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Https"
    request_type        = "GET"
  }
}


#AFD Origins
resource "azurerm_cdn_frontdoor_origin" "afd_origins" {
  name                           = var.afd_origins_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  enabled                        = true
  certificate_name_check_enabled = true
  host_name                      = var.origin_host_header
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.origin_host_header
  priority                       = 1
  weight                         = 1000
}

#AFD ruleset
resource "azurerm_cdn_frontdoor_rule_set" "afd_ruleset" {
  name                     = var.afd_ruleset_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.afd_profile.id
}

#AFD Default rule for AFD Ruleset
resource "azurerm_cdn_frontdoor_rule" "afd_ruleset_default" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.afd_origin_group, azurerm_cdn_frontdoor_origin.afd_origins]
  name                      = "defaultrule"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.afd_ruleset.id
  order                     = 1
  behavior_on_match         = "Stop"

  conditions {
    url_path_condition {    
      operator         = "BeginsWith"
      negate_condition = false
      match_values     = ["wp-content/uploads/"]
      transforms       = ["Lowercase"]
    }
  }

  actions {
    route_configuration_override_action {
      cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
      compression_enabled           = true
      query_string_caching_behavior = "UseQueryString"
      cache_behavior                = "OverrideAlways"
      cache_duration                = "3.00:00:00"
      forwarding_protocol           = "MatchRequest"
    }
  }
}


#AFD Endpoint Route
resource "azurerm_cdn_frontdoor_route" "afd_default_route" {
  name                          = var.afd_default_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afd_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afd_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.afd_origins.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.afd_ruleset.id]
  enabled                       = true
  forwarding_protocol           = "MatchRequest"
  https_redirect_enabled        = true
  patterns_to_match             = ["/*"]
  supported_protocols           = ["Http", "Https"]
  link_to_default_domain        = true
}


#AFD CacheStaticFiles Ruleset for AFD 
resource "azurerm_cdn_frontdoor_rule" "afd_ruleset_cache_static_files" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.afd_origin_group, azurerm_cdn_frontdoor_origin.afd_origins]
  name                      = "CacheStaticFiles"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.afd_ruleset.id
  order                     = 2
  behavior_on_match         = "Stop"

  conditions {
    url_path_condition {    
      operator         = "BeginsWith"
      negate_condition = false
      match_values     = ["wp-includes/","wp-content/themes/"]
      transforms       = ["Lowercase"]
    }
    url_file_extension_condition {
      operator         = "Equal"
      negate_condition = false
      match_values     = ["css","js","gif","png","jpg","ico","ttf","otf","woff","woff2"]
      transforms       = ["Lowercase"]
    }
  }

  actions {
    route_configuration_override_action {      
      compression_enabled           = true
      query_string_caching_behavior = "UseQueryString"
      cache_behavior                = "OverrideAlways"
      cache_duration                = "3.00:00:00"
    }
  }
}