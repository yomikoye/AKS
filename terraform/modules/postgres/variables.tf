variable "server_name" {
  type        = string
  description = "PostgreSQL server name."
}

variable "rg_name" {
  type        = string
  description = "PostgreSQL server resource group."
}

variable "location" {
  type        = string
  default     = "westeurope"
  description = "Deployment region."
}

variable "server_version" {
  type        = string
  default     = "14"
  description = "The version of the PostgreSQL server."
}

variable "admin_login" {
  type        = string
  description = "The username for the PostgreSQL server."
  sensitive   = true

}

variable "admin_password" {
  type        = string
  description = "The administrator password for the PostgreSQL server."
  sensitive   = true
}

variable "availability_zone" {
  type        = string
  default     = "1"
  description = "The availability zone of the PostgreSQL server."
}

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "retain backups for how long."
}

variable "storage_size" {
  type        = number
  default     = 65536
  description = "The storage capacity in MB of the PostgreSQL server."
}

variable "sku_name" {
  type        = string
  default     = "GP_Standard_D2ds_v4"
  description = "The SKU name for the PostgreSQL server."
}

variable "environment" {
  type        = string
  description = "The environment of the PostgreSQL server."
  default     = "dev"
}

variable "server_config" {
  type        = string
  default     = "PG_BUFFERCACHE,PG_STAT_STATEMENTS, UUID-OSSP"
  description = "The PostgreSQL server configuration."
}

variable "database_names" {
  type        = list(string)
  default     = ["mordor", "gondor", "rohan"]
  description = "The database(s) to be created."
}

variable "database_collation" {
  type        = string
  default     = "en_US.UTF8"
  description = "The collation of the PostgreSQL database."
}

variable "database_charset" {
  type        = string
  default     = "UTF8"
  description = "The character set of the PostgreSQL database."
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "The list of allowed CIDRs."
}

variable "lock_enabled" {
  type        = bool
  default     = true
  description = "set to True to lock."
}

variable "enable_pgbouncer" {
  type        = bool
  default     = false
  description = "set to True to enable pgBouncer."
}