terraform {
  backend "local" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.30.0"
    }
    azapi = {
      source = "Azure/azapi"
    }
  }
}

provider "azapi" {
  # More information on the authentication methods supported by
  # the AzApi Provider can be found here:
  # https://registry.terraform.io/providers/Azure/azapi/latest/docs

  # subscription_id = "..."
  # client_id       = "..."
  # client_secret   = "..."
  # tenant_id       = "..."
}

provider "azurerm" {
  features {}
}