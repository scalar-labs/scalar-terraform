terraform {
  required_version = "~> 0.14.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.48"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 2.3"
    }
  }
}
