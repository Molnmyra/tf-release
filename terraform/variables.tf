variable "subscription_id" {
  type        = string
  description = "Used to configure azurerm provider"
}

variable "azure_environment" {
  type        = string
  description = "Put desired environment here. E.g 'dev', 'test', 'prd'"
}

variable "azure_location" {
  type        = string
  default     = "swedencentral"
  description = "Default location for resource deployment"
}