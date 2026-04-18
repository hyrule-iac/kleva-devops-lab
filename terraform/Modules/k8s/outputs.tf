output "namespace_created" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "namespace_created" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}
