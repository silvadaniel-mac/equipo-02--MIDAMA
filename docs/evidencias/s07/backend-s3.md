# S07 — Validación real del backend remoto S3

Fecha: 26/11/2026. Entorno: AWS Academy Learner Lab, CloudShell en us-east-1; Terraform 1.13.4 (descarga con comprobación SHA-256).

## Evidencia observada en las capturas del integrante

| Prueba | Resultado |
| --- | --- |
| Versionamiento S3 | Enabled |
| Raíz Terraform de MIDAMA: init con backend S3 | Inicialización correcta |
| Raíz Terraform de MIDAMA: validate | Success; provider Kubernetes 2.38.0 |
| Prueba aislada terraform_data.test | Apply complete: 1 agregado, 0 cambiados, 0 destruidos |
| Operación concurrente plan | Error acquiring the state lock, S3 HTTP 412 PreconditionFailed; bloqueo esperado |
| Lectura posterior del state | terraform_data.test |
| Metadatos del objeto | VersionId presente, cifrado AES256, 863 bytes |
| Consola S3 | Objeto terraform.tfstate visible, 26/11/2026 |

La raíz de MIDAMA se inicializó con bucket autorizado y use_lockfile=true. Para comprobar escritura y exclusión mutua se utilizó una raíz aislada con otro prefijo (aulaviva/lab/backend-test/), sin crear servidores ni modificar Kubernetes. La primera operación permaneció activa 30 segundos y una segunda operación fue rechazada. No se publica el contenido del state, credenciales, ID de cuenta, correo ni identificadores de sesión. Las capturas originales son del integrante; este documento transcribe sus resultados y no es una ejecución de CI.

## Reproducción

En CloudShell de una cuenta autorizada, con Terraform >= 1.10, crear un directorio temporal y configurar un bucket propio privado, versionado y cifrado, usando una key exclusiva para la prueba. Ejemplo de main.tf:

```hcl
terraform {
  backend "s3" {}
}
resource "terraform_data" "test" {
  input = "AulaViva MIDAMA S07"
  provisioner "local-exec" {
    command = "sleep 30"
  }
}
```

Inicializar con `terraform init -backend-config=backend.hcl` y parámetros bucket, key exclusiva, region, encrypt=true, use_lockfile=true. Validar. Ejecutar apply en una terminal y plan con -lock-timeout=0s en otra mientras apply está activo. El segundo debe fallar específicamente por bloqueo; después de terminar el primero, comprobar state list y head-object sin descargar ni mostrar el state. No usar -lock=false. No versionar backend.hcl ni estados.

## Alcance

La raíz Kubernetes fue validada e inicializada con S3, pero no se aplicó contra un clúster desde AWS Academy. La aplicación de Kubernetes se verificó por separado en kind en [S07](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184474). El laboratorio universitario puede expirar; no representa infraestructura permanente ni una factura de producción.
