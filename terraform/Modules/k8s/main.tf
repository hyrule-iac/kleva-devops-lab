# -----------------------------------------------------------------------------------------
# K8S BASE INFRASTRUCTURE
# Purpose: Provisioning of logical isolation (Namespaces) and shared configurations.
# -----------------------------------------------------------------------------------------

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

# Configuration-as-Code: Injecting environment-specific settings via ConfigMap.
# This decouples infrastructure values from the application runtime for easier maintenance and changes 

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
