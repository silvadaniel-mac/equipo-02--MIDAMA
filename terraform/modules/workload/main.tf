terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38.0"
    }
  }
}

resource "kubernetes_namespace_v1" "team" {
  metadata {
    name = "equipo-02"
    labels = {
      "app.kubernetes.io/part-of"          = "aulaviva"
      "pod-security.kubernetes.io/enforce" = "restricted"
    }
  }
}

resource "kubernetes_secret_v1" "placeholder" {
  metadata {
    name      = "aulaviva-placeholder"
    namespace = kubernetes_namespace_v1.team.metadata[0].name
  }
  type = "Opaque"
  # Texto ficticio: no es contraseña ni habilita conexión a una base de datos.
  data = { LAB_PLACEHOLDER = "not-a-credential" }
}

output "namespace" {
  value = kubernetes_namespace_v1.team.metadata[0].name
}
