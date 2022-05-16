locals {
  prefix = substr(sha1("${data.azurerm_client_config.current.tenant_id}/${data.azurerm_client_config.current.subscription_id}"), 0, 5)
}

resource "azurerm_private_dns_zone" "private_dns" {
  name                = "${var.azure_environment}.azure.local"
  resource_group_name = "${local.prefix}-rg-${var.azure_environment}-environment"

  tags = {
    "commit"      = var.github_sha
    "environment" = var.azure_environment
    "test"        = "ok2"
  }
}
