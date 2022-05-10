resource "azurerm_resource_group" "example" {
  name     = "tf-release-${var.azure_environment}"
  location = var.azure_location
}