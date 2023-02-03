locals {
  istio_charts_url = "https://istio-release.storage.googleapis.com/charts"
}

resource "kubernetes_namespace" "istio_system" {
  metadata {
    name = "istio-system"
  }
}

resource "helm_release" "istio_base" {
  name            = "istio-base"
  repository      = local.istio_charts_url
  chart           = "base"
  version         = var.istio_version
  wait            = "true"
  timeout         = 600
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name
}

resource "helm_release" "istiod" {
  name            = "istiod"
  repository      = local.istio_charts_url
  chart           = "istiod"
  version         = var.istio_version
  wait            = "true"
  timeout         = 600
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_system.metadata.0.name

  # values = [<<EOF
  #   meshConfig:
  #     accessLogFile: "/dev/stdout"
  # EOF
  # ]

  set {
    name  = "meshConfig.accessLogFile"
    value = "/dev/stdout"
  }

  depends_on = [helm_release.istio_base]
}

resource "kubernetes_namespace" "istio_ingress" {
  metadata {
    name = "istio-ingress"

    labels = {
      "istio-injection" = "enabled"
    }
  }
}

resource "helm_release" "istio_ingress" {
  name            = "istio-ingress"
  repository      = local.istio_charts_url
  chart           = "gateway"
  version         = var.istio_version
  wait            = "true"
  timeout         = 600
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.istio_ingress.metadata.0.name

  values = [<<EOF
    service:
      loadBalancerIP: "${var.internal_lb_ip}"
  EOF
  ]

  depends_on = [helm_release.istiod]
}
