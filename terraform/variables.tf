variable "app_namespace" {
  description = "Namespace para la aplicación .NET"
  type        = string
  default     = "app"
}

variable "monitoring_namespace" {
  description = "Namespace para las herramientas de monitoreo"
  type        = string
  default     = "monitoring"
}

variable "grafana_admin_password" {
  description = "Password for Grafana admin user"
  type        = string
  sensitive   = true  # importante para que no aparezca en logs
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}

variable "kubeconfig_path" {
  description = "K8s config path"
  type = string
  default = "~/.kube/config"
}