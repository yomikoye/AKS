
resource "helm_release" "kube_prometheus_stack" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  create_namespace = true
  namespace        = var.namespace
  version          = var.chart_version

  wait            = "true"
  timeout         = 600
  cleanup_on_fail = true
  force_update    = false

  values = [ file("${path.module}/config/kube-prometheus-values.yaml")]
  ]
}