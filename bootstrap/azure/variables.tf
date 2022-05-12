variable "tenant_id" {
  type        = string
  description = "Used to configure azurerm and azuread provider"
}

variable "subscription_id" {
  type        = string
  description = "Used to configure azurerm provider"
}

variable "default_location" {
  type        = string
  description = "Azure region for deployment"
  default     = "swedencentral"
}

variable "environments" {
  type        = set(string)
  description = "List of environment prefixes"
  default     = ["dev", "test", "prod"]
}

variable "github_token" {
  type        = string
  sensitive   = true
  description = "Used for configuring github provider"
}

variable "github_organization" {
  type        = string
  description = "Used for configuring github provider"
}

variable "github_repo" {
  type        = string
  description = "GitHub Repository to bootstrap"
}