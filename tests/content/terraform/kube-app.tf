resource "kubernetes_namespace" "kube-app" {
  metadata {
    name = var.kube_app_namespace
  }
}

resource "kubernetes_config_map" "kube-app" {

  metadata {
    name      = "kube-app"
    namespace = var.kube_app_namespace
  }

  data = {
    FOO = var.kube_app_val
  }

  depends_on = [
    kubernetes_namespace.kube-app
  ]

}
