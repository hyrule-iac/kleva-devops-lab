output "app_namespace_created" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "monitoring_namespace_created" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}
