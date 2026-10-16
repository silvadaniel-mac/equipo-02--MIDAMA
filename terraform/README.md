# Terraform · AulaViva S07

Requisitos: Terraform **1.10 o superior** (CI usa 1.13.4), kubectl, clúster kind `aulaviva` y kubeconfig válido. Provider Kubernetes `~> 2.38.0`.

## Responsabilidades

Terraform administra únicamente el namespace `equipo-02` y `aulaviva-placeholder`, un Secret Opaque con texto ficticio. Kustomize administra Deployment, Service, Ingress, ConfigMap y HPA. Este módulo no crea EKS, VPC, RDS, un bucket ni credenciales AWS.

## Opción A: laboratorio local sin AWS

Desde la raíz del repositorio, después de crear el clúster:

```bash
terraform -chdir=terraform/lab init
terraform -chdir=terraform/lab validate
terraform -chdir=terraform/lab plan -out=lab.tfplan
terraform -chdir=terraform/lab apply lab.tfplan
```

`terraform/lab/` usa backend local explícito y el mismo módulo que la raíz remota. Su state y el plan quedan ignorados por Git. No usar ambas raíces sobre el mismo namespace.

## Opción B: estado remoto S3

Esta opción requiere un bucket **preexistente** de una cuenta autorizada, privado, cifrado, con versionado y bloqueo de acceso público. El rol necesita acceso al objeto state y adquirir/eliminar el objeto `.tflock`. No introducir access keys en archivos versionados.

```bash
cp terraform/backend.hcl.example terraform/backend.hcl
# Editar bucket, key y region con datos reales. backend.hcl no se versiona.
terraform -chdir=terraform init -backend-config=backend.hcl
terraform -chdir=terraform validate
terraform -chdir=terraform plan -out=remote.tfplan
terraform -chdir=terraform apply remote.tfplan
```

Usar credenciales de perfil/SSO o rol, no secretos en HCL. `use_lockfile = true` usa locking nativo de S3 y requiere Terraform >= 1.10. Un state por ambiente (`dev`, `stg`, `prod`) y por dominio; cambiar la `key` para separarlos. No migrar el laboratorio al backend remoto sin revisar primero el state y el ownership de recursos.

## Validación sin una cuenta cloud

```bash
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform init -backend=false
terraform -chdir=terraform validate
```

Esto valida la sintaxis/provider de la raíz remota. No comprueba conectividad S3, permisos, locking ni la aplicación en un clúster.

## Limpieza del laboratorio

```bash
kubectl delete -k k8s/
terraform -chdir=terraform/lab destroy
kind delete cluster --name aulaviva
```

La destrucción del namespace elimina sus recursos. Ejecutar estos comandos solo sobre el clúster local de esta guía y el state que efectivamente lo administra.
