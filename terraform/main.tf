# Namespaces declarativos
resource "kubernetes_namespace" "app" {
  metadata {
    name = var.app_namespace
    labels = {
      environment = var.environment
    }
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.monitoring_namespace
    labels = {
      environment = var.environment
    }
  }
}

# Configuración inyectada vía Terraform
resource "kubernetes_config_map" "kleva_settings" {
  metadata {
    name      = "kleva-settings"
    namespace = kubernetes_namespace.app.metadata[0].name
  }

  data = {
    "APP_ENV"     = var.environment
    "API_TIMEOUT" = "30s"
  }
}

# Despliegue de Grafana usando Helm
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }

  # ESTO ES LO QUE HACE LA MAGIA:
  set {
    name  = "sidecar.dashboards.enabled"
    value = "true"
  }
  set {
    name  = "sidecar.datasources.enabled"
    value = "true"
  }
}