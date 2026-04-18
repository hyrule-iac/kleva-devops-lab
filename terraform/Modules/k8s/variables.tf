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
  description = "Password para el admin de Grafana"
  type        = string
  default     = grafana_admin_password
  sensitive   = true # Esto oculta el valor en los logs
}

variable "environment" {
  description = "Ambiente de despliegue"
  type        = string
  default     = "dev"
}