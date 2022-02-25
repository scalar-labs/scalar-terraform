terraform {
  required_version = "~> 1.0.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=1.38.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
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
