variable "tags" {
  description = "resource tags"
  default     = {}
}

variable "resource_group_name" {
  description = "Resource Group to use"
  default     = ""
}

variable "origin_host_header" {
  description = "The host header AFD provider will send along with content requests to origins"
  default     = ""
}



variable "location" {
  description = "Location"
  default     = ""
}


variable "sku_name" {
  description = "The pricing related information of current AFD profile"
  type        = string
  default     = "Standard_AzureFrontDoor"
  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.sku_name)
    error_message = "Argument 'AFD Sku' must one of 'Standard_AzureFrontDoor', or 'Premium_AzureFrontDoor'."
  }
}



/*
Azure Front Door Policy vars
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

variable "afd_default_route_name" {
  description = "Frontdoor Default Route name"
  default     = "default-route"
}