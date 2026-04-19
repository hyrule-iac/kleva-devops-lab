# -----------------------------------------------------------------------------------------
# OBSERVABILITY STACK: Grafana Deployment
# Strategy: Helm-based deployment with dynamic configuration via Sidecars.
# -----------------------------------------------------------------------------------------
# Deploying Grafana through HELM on Kubernetes cluster also into monitoring namespace

resource "kubernetes_secret_v1" "grafana" {
  metadata {
    name = "grafana-secret"
    namespace = var.monitoring_namespace
  }
}
resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.monitoring_namespace

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

#Argo Rollouts Template
resource "kubernetes_manifest" "promote_analysis" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "AnalysisTemplate"
    metadata = {
      name      = "error-rate-check"
      namespace = var.app_namespace
    }
    spec = {
      args = [{ name = "service-name" }]
      metrics = [{
        name     = "error-rate"
        successCondition = "result[0] < 0.01" # Success if < 1%
        interval = "1m"
        count    = 5 #Check interval set for 5 mins
        provider = {
          prometheus = {
            # Prom URL
            address = "http://prometheus-operated.monitoring.svc.cluster.local:9090"
            # .Net Metrics
            query   = "sum(rate(kleva_http_requests_total{service=\"{{args.service-name}}\",status_code=~\"5.*\"}[2m])) / sum(rate(kleva_http_requests_total{service=\"{{args.service-name}}\"}[2m]))"
          }
        }
      }]
    }
  }
}