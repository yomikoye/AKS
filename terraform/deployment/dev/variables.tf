variable "environment" {
  description = "The environment name"
  type        = string
  default     = "dev"
}
variable "rg_name" {
  description = "The name of the resource group name"
  type        = string
  default     = "rg-dev"
}
variable "location" {
  description = "The location of the resource group"
  type        = string
  default     = "westeurope"
}
variable "keyvault_name" {
  type        = string
  description = "Name of the Key Vault"
  default     = "keyvault-koyecloud"
}
variable "enable_rbac" {
  type        = bool
  description = "Enable RBAC for the Key Vault"
  default     = false
}

variable "server_name" {
  type        = string
  description = "The name of the PostgreSQL server."
}

variable "admin_login" {
  type        = string
  description = "The username for the PostgreSQL server."
  sensitive   = true
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "The list of allowed CIDRs."
}

variable "postgres_sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "The SKU name for the PostgreSQL server."
}

variable "enable_pgbouncer" {
  type        = bool
  default     = false
  description = "set to True to enable pgBouncer."
}