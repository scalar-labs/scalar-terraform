terraform {
  required_version = "~> 1.0.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.70"
    }
  }
}
