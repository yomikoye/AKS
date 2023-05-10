variable "namespace" {
    description = "value for namespace"
    default     = "monitoring"
}

variable "chart_version" {
  description = "value for the kube-prometheus-stack chart version"
    default     = "45.0.0"
}