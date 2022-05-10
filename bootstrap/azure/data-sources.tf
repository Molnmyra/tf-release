data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "github_user" "current" {
  username = ""
}

data "github_repository" "tfstate" {
  full_name = "${var.github_organization}/${var.github_repo}"
}