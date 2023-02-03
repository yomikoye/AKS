variable "istio_version" {
  description = "Istio version"
  default     = "1.16.1"
}

variable "internal_lb_ip" {
  description = "IP address for internal LB (ATTENTION: look at subnets in virtual network and choose unused IP address from ENV_NAME-aks subnet)"
}
