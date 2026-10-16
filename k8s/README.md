# Laboratorio S07 · AulaViva en Kubernetes

## Prerrequisitos

- Docker Desktop/Engine con contenedores Linux.
- kind, kubectl y Terraform >= 1.10.
- Node.js 24 para ejecutar las pruebas sin Docker.
- Recursos sugeridos: 4 CPU y 6 GB de memoria para Docker.

La base de despliegue expone `/`, `/healthz` y `/readyz`. Los endpoints académicos del contrato S05 siguen pendientes. El laboratorio no contiene datos reales ni servicios cloud de pago.

## 1. Construir e iniciar el clúster

Desde la raíz del repositorio:

```bash
node --test services/api/server.test.mjs
docker build -t aulaviva-api:local .
docker image inspect aulaviva-api:local --format '{{.Size}} bytes; user={{.Config.User}}'
kind create cluster --name aulaviva
kubectl config use-context kind-aulaviva
kind load docker-image aulaviva-api:local --name aulaviva
```

El build comprueba sintaxis y ejecuta pruebas; el runtime es distroless, UID/GID 65532, sin dependencias npm de desarrollo.

## 2. Crear namespace y Secret con Terraform

```bash
terraform -chdir=terraform/lab init
terraform -chdir=terraform/lab plan -out=lab.tfplan
terraform -chdir=terraform/lab apply lab.tfplan
```

Para una cuenta con backend S3 habilitado, usar la [raíz remota](../terraform/README.md) en lugar de la raíz local. No usar ambas para los mismos objetos.

## 3. Instalar métricas y aplicar Kustomize

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.2/components.yaml
# Solo kind: su certificado kubelet no tiene las SAN verificables por Metrics Server.
kubectl patch deployment metrics-server -n kube-system --type=json -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
kubectl rollout status deployment/metrics-server -n kube-system --timeout=180s
kubectl apply --dry-run=server -k k8s/
kubectl apply -k k8s/
kubectl rollout status deployment/aulaviva-api -n equipo-02 --timeout=180s
kubectl get all -n equipo-02
kubectl top pods -n equipo-02
```

El flag de certificados es exclusivo del laboratorio kind. El Metrics Server puede necesitar un minuto para disponer de las primeras muestras.

## 4. Verificar HTTP

```bash
kubectl port-forward -n equipo-02 service/aulaviva-api 8080:80
```

En otra terminal:

```bash
curl --fail http://localhost:8080/readyz
curl --fail http://localhost:8080/healthz
curl http://localhost:8080/api/v1/contents
```

El último responde `501 not_implemented`, porque no existe todavía la implementación de negocio.

El Ingress usa `aulaviva.local` y clase `nginx`. La definición por sí sola no instala un controlador ni DNS. Si el laboratorio ya dispone de un controlador compatible, resolver el host hacia su IP y consultar `http://aulaviva.local/readyz`. El workflow comprueba el manifiesto y la conectividad por Service; la prueba HTTP vía Ingress y TLS quedan fuera de esa ejecución.

## 5. Acreditar HPA bajo carga

```bash
bash scripts/verify-hpa.sh
```

El script exige contexto `kind-aulaviva`, activa temporalmente el endpoint de carga, ejecuta un Job durante 5 minutos, exige crecimiento por encima de 2 réplicas y espera regreso a 2. Guarda los resultados en `artifacts/` y restaura la configuración al salir. Verificar Metrics Server y requests de CPU si aparecen métricas `<unknown>`.

Tomar una captura **real** de `kubectl get all -n equipo-02` y añadirla al README principal, como pide el PPT. Los logs de Actions se conservan como evidencia técnica adicional.

## 6. Publicar en GHCR y desplegar por digest

El workflow `Plataforma S07` tiene validación en PR y publicación en `push` a `main` o ejecución manual (`workflow_dispatch`). Publica `ghcr.io/silvadaniel-mac/aulaviva-api:sha-<commit>`, conserva el digest real y genera `deploy-ghcr.yaml`. No publica `:latest`.

Después de publicar, descargar el artefacto `s07-ghcr-<sha>` desde Actions. Contiene `image-digest.txt`, `deploy-ghcr.yaml` y el resultado del pull por digest. Revisar la visibilidad del paquete GHCR: hacerlo público si corresponde al proyecto o configurar un `imagePullSecret` en el entorno destino sin versionar credenciales.

```bash
bash scripts/deploy-s07.sh "$(cat image-digest.txt)"
```

No reemplazar el digest por un valor inventado. La publicación requiere permiso `packages:write` del workflow y que el paquete permita acceso al repositorio.

## Troubleshooting

| Síntoma | Revisión |
| --- | --- |
| `ImagePullBackOff` con `:local` | Cargar la imagen con `kind load docker-image` y mantener el nombre del clúster |
| `CreateContainerConfigError` | Aplicar primero el módulo Terraform que crea el Secret ficticio |
| HPA `<unknown>` | Revisar `kubectl top`, Metrics Server y requests CPU |
| Terraform no conecta | Revisar contexto `kind-aulaviva` y kubeconfig |
| HTTP por Ingress no responde | Instalar/configurar el controlador y resolución del host; usar port-forward para aislar el problema |
| GHCR devuelve 401/403 | Comprobar acceso del repositorio al paquete y credenciales de pull |
