output "namespace_created" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "grafana_status" {
  value = helm_release.grafana.status
}