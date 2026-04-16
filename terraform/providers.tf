# Here we declare the Terraform block for the  version and the providers we will use in our configuration. 
# We also configure the Kubernetes provider to connect to our cluster using the kubeconfig file.
terraform {
  required_version = "~> 1.14.0"

  # HCP Terraform Cloud block
  # This will activate the Terraform Cloud integration, allowing us to manage our state and run Terraform operations in the cloud.
  cloud {
    organization = "Hyrule-Nexus"

    workspaces {
      name = "Demo01"
    }
  }

  # Here we are declaring the required providers for our Terraform configuration, Kubernetes and Helm, with their respective versions.
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