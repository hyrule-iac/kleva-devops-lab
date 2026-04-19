# -----------------------------------------------------------------------------------------
# ROOT ORCHESTRATOR
# Purpose: Linking infrastructure modules and managing global variables.
# -----------------------------------------------------------------------------------------

# M1 : Core Infrastructure - Namespacing and Monitoring
module "k8s" {
  source = "./Modules/k8s"
  app_namespace = var.app_namespace
  monitoring_namespace = var.monitoring_namespace
  environment = var.environment
  grafana_admin_password = var.grafana_admin_password 
}

# M2 : Observability Stack trough HELM (Grafana + Prometheus)
module "monitoring" {
  source = "./Modules/monitoring"
  monitoring_namespace = var.monitoring_namespace
  grafana_admin_password = var.grafana_admin_password
  environment = var.environment
  depends_on = [module.k8s]
}
