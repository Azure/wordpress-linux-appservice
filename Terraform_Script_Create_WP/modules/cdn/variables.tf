variable "tags" {
  description = "resource tags"
  default     = {}
}

variable "cdn_profile_name" {
  description = "CDN Profile Name"
  default     = ""

}
variable "location" {
  description = "Location"
  default     = ""
}

variable "resource_group_name" {
  description = "Resource Group to use"
  default     = ""
}

variable "sku" {
  description = "The pricing related information of current CDN profile"
  type        = string
  default     = "Standard_Microsoft"
  validation {
    condition     = contains(["Standard_Akamai", "Standard_ChinaCdn", "Standard_Microsoft", "Standard_Verizon", "Premium_Verizon"], var.sku)
    error_message = "Argument 'CDN Sku' must one of 'Standard_Akamai', 'Standard_ChinaCdn', 'Standard_Microsoft', 'Standard_Verizon' or 'Premium_Verizon'."
  }
}

variable "cdn_endpoint_name" {
  description = "CDN Endpoint name"
  default     = ""
}

variable "is_compression_enabled" {
  description = "Indicates whether compression is to be enabled."
  default     = true
  type        = bool
}

variable "origin" {
  type = object({
    name       = string,
    host_name  = string,
    http_port  = number,
    https_port = number
  })
}

variable "origin_host_header" {
  description = "The host header CDN provider will send along with content requests to origins"
  default     = ""
}
