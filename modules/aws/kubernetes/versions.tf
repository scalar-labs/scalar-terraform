terraform {
  required_version = "~> 0.14.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 1.13"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1"
    }

    http = {
      source  = "terraform-aws-modules/http"
      version = "~> 2.4"
    }
  }
}
