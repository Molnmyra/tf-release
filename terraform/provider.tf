terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.99"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.2.2"
    }
  }

  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}