variable "environment" {
  description = "value for the environment"
  default     = "dev"
}

variable "acr_name" {
  description = "value for the nameof the Azure Container Registry"
  default     = "koyecloud"
}

variable "rg_name" {
  description = "value for the resource group name"
}

variable "location" {
  description = "value for the location"
  default     = "West Europe"
}

variable "sku" {
  description = "value for the SKU"
  default     = "Standard"
}   