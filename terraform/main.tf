# Im declaring the namespaces for:# *the application, *Terraform , *monitoring components, 
# We are setting up a ConfigMap to inject configuration settings into the application namespace. 
# Configmaps are a Kubernetes resource that allows us to store configuration data in key-value pairs, 
# This can be consumed by our applications running in the cluster.
# Ill also deploy Grafana using Helm in the monitoring namespace, 
# By enabling sidecar support for dashboards and datasources so they will come in as ConfigMaps and showed in grafana without the need to redeploy it.

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

# This ConfigMap will be used to inject configuration settings into the application namespace.
# The configuration is Terraform code, but it will be rendered as a Kubernetes ConfigMap in the cluster.
# Allowing us to manage application configuration as code, and easily update it by changing the Terraform code and applying it again.

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

  # Enabling grafana sidecar for dashboards and datasources
  # This will allow to manage dashboards and datasources as code, 
  # By creating ConfigMaps with the appropriate labels in the app namespace.
  # A ConfigMap with the label "grafana_dashboard" will be picked up as a dashboard, 
  # and a ConfigMap with the label "grafana_datasource" will be picked up as a datasource.

  set {
    name  = "sidecar.dashboards.enabled"
    value = "true"
  }
  set {
    name  = "sidecar.datasources.enabled"
    value = "true"
  }
}