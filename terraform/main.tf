terraform {
  required_version = ">= 1.10, < 2.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
  }
  # Backend parcial: completar con -backend-config=backend.hcl.
  backend "s3" {}
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kube_context
}

module "workload" {
  source = "./modules/workload"
}
