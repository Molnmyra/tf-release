terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 4.0"
    }
  }

  backend "local" {}
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azuread" {
  tenant_id = var.tenant_id
}

provider "github" {
  token = var.github_token
  owner = var.github_organization
}