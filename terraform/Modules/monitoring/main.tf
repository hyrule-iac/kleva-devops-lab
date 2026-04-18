# -----------------------------------------------------------------------------------------
# OBSERVABILITY STACK: Grafana Deployment
# Strategy: Helm-based deployment with dynamic configuration via Sidecars.
# -----------------------------------------------------------------------------------------
# Deploying Grafana through HELM on Kubernetes cluster also into monitoring namespace

resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  set {
    name  = "adminPassword"
    value = var.grafana_admin_password
  }
    # DYNAMIC CONFIGURATION: Enabling Sidecar containers to auto-discover 
    # Dashboards and Datasources stored as Kubernetes ConfigMaps.
    # This enables a "GitOps" approach for observability dashboards.
  set {
    name  = "sidecar.dashboards.enabled"
    value = "true"
  }
  set {
    name  = "sidecar.datasources.enabled"
    value = "true"
  }
}