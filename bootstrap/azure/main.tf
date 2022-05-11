locals {
  prefix = substr(sha1("${data.azurerm_client_config.current.tenant_id}/${data.azurerm_client_config.current.subscription_id}"), 0, 5)
  principals = setunion(local.planners,local.appliers)
  planners = toset([for p in var.environments : "${p}-plan"])
  appliers = toset([for p in var.environments : "${p}-apply"])
}

resource "azurerm_resource_group" "tfstate" {
  for_each = var.environments

  name     = "${local.prefix}-rg-${each.key}-tfstate"
  location = var.default_location
}

resource "azurerm_resource_group" "environments" {
  for_each = var.environments

  name     = "${local.prefix}-rg-${each.key}-environment"
  location = var.default_location
}

resource "azurerm_storage_account" "tfstate" {
  for_each = var.environments

  name                     = "${local.prefix}${each.key}tfstate"
  resource_group_name      = azurerm_resource_group.tfstate[each.key].name
  location                 = azurerm_resource_group.tfstate[each.key].location
  account_kind             = "BlockBlobStorage"
  account_tier             = "Premium"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  for_each = azurerm_storage_account.tfstate

  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate[each.key].name
  container_access_type = "private"
}

resource "azuread_application" "tfstate" {
  for_each = local.principals

  display_name = "${local.prefix}-sp-${each.key}"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "tfstate" {
  for_each = local.principals

  application_id               = azuread_application.tfstate[each.key].application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "time_rotating" "tfstate" {
  rotation_days = 1
}

resource "azuread_service_principal_password" "tfstate" {
  for_each = local.principals

  service_principal_id = azuread_service_principal.tfstate[each.key].object_id
  rotate_when_changed = {
    rotation = time_rotating.tfstate.id
  }
}

resource "azurerm_role_assignment" "tfstate_plan" {
  for_each = local.planners

  scope                = azurerm_storage_account.tfstate[split("-",each.key)[0]].id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azuread_service_principal.tfstate[each.key].object_id
}

resource "azurerm_role_assignment" "tfstate_apply" {
  for_each = local.appliers

  scope                = azurerm_storage_account.tfstate[split("-",each.key)[0]].id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.tfstate[each.key].object_id
}

resource "azurerm_role_assignment" "environments" {
  for_each = local.appliers

  scope                = azurerm_resource_group.environments[split("-",each.key)[0]].id
  role_definition_name = "Owner"
  principal_id         = azuread_service_principal.tfstate[each.key].object_id
}

resource "github_repository_environment" "tfstate" {
  for_each = local.principals

  environment = each.key
  repository  = data.github_repository.tfstate.name
  reviewers {
    users = split("-",each.key)[1] == "apply" ? [data.github_user.current.id] : []
  }
  deployment_branch_policy {
    protected_branches     = true
    custom_branch_policies = false
  }
}

resource "github_actions_environment_secret" "client_id" {
  for_each = local.principals

  repository      = data.github_repository.tfstate.name
  environment     = github_repository_environment.tfstate[each.key].environment
  secret_name     = "TF_ARM_CLIENT_ID"
  plaintext_value = azuread_service_principal.tfstate[each.key].application_id
}

resource "github_actions_environment_secret" "tenant_id" {
  for_each = local.principals

  repository      = data.github_repository.tfstate.name
  environment     = github_repository_environment.tfstate[each.key].environment
  secret_name     = "TF_ARM_TENANT_ID"
  plaintext_value = azuread_service_principal.tfstate[each.key].application_tenant_id
}

resource "github_actions_environment_secret" "subscription_id" {
  for_each = local.principals

  repository      = data.github_repository.tfstate.name
  environment     = github_repository_environment.tfstate[each.key].environment
  secret_name     = "TF_ARM_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.current.subscription_id
}

resource "github_actions_environment_secret" "client_secret" {
  for_each = local.principals

  repository      = data.github_repository.tfstate.name
  environment     = github_repository_environment.tfstate[each.key].environment
  secret_name     = "TF_ARM_CLIENT_SECRET"
  plaintext_value = azuread_service_principal_password.tfstate[each.key].value
}

resource "github_actions_secret" "demo_prefix" {

  repository      = data.github_repository.tfstate.name
  secret_name     = "DEMO_PREFIX"
  plaintext_value = local.prefix
}