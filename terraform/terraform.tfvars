
# Nombres de los namespaces
app_namespace        = "app"
monitoring_namespace = "monitoring"

# Configuración de ambiente
environment = "dev"

# NOTA: La contraseña de Grafana (grafana_admin_password) 
# NO la pongas aquí si vas a subir este archivo a Git.
# Es mejor pasarla como secreto en el pipeline o dejar que use el default.

terraform {
  required_version = "~> 1.5.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

