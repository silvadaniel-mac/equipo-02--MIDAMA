# Raíz alternativa local para CI y equipos sin bucket AWS.
# No ejecutar simultáneamente con la raíz remota sobre el mismo namespace.
terraform {
  required_version = ">= 1.10, < 2.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
  }
  backend "local" {}
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}

variable "kube_context" {
  type    = string
  default = "kind-aulaviva"
}

provider "kubernetes" {
  config_path    = pathexpand(var.kubeconfig_path)
  config_context = var.kube_context
}

module "workload" {
  source = "../modules/workload"
}

output "namespace" {
  value = module.workload.namespace
}
