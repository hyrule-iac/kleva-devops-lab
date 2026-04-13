terraform {
  required_version = ">= 1.5.0"

  # CONFIGURACIÓN DEL BACKEND CLOUD
  cloud {
    organization = "Hyrule-Nexus" # Cámbialo por tu nombre de org en HCP

    workspaces {
      name = "Demo01" # El nombre del workspace que creaste
    }
  }

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