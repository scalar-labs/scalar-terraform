terraform {
  required_version = "~> 1.0.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.91"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 1.4"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 2.3"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }
  }
}
