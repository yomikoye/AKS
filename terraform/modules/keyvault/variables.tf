variable "environment" {
  description = "The environment name"
  type        = string
  default     = "dev"
}

variable "keyvault_name" {
  type        = string
  description = "Name of the Key Vault"
  default     = "koyecloud"
}

variable "rg_location" {
  type        = string
  description = "Location of the resource group"
  default     = "westeurope"
}

variable "rg_name" {
  type        = string
  description = "Name of the resource group"
  default     = "dev"
}

variable "enable_rbac" {
  type        = bool
  description = "Enable RBAC for the Key Vault"
  default     = false
}