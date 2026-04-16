#This output blocks are used to display the results of our Terraform configuration after it has been applied.
#First output block will show the name of the namespace that was created for the application 
#Second output block will show the status of the Grafana release that was deployed using Helm.

output "namespace_created" {
  value = kubernetes_namespace.app.metadata[0].name
}

output "grafana_status" {
  value = helm_release.grafana.status
}