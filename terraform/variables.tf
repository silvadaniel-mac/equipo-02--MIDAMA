variable "kubeconfig_path" {
  description = "Archivo kubeconfig del clúster de laboratorio."
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Contexto explícito para evitar aplicar en otro clúster."
  type        = string
  default     = "kind-aulaviva"
}
