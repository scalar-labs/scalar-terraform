terraform {
  required_version = "~> 0.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.29"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}
