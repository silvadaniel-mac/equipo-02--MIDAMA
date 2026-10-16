# S07 · Contenedores, Kubernetes e Infraestructura como Código

**Iniciativa:** AulaViva. **Equipo:** MIDAMA. **Fuente:** PPT `S07___Contenedores__Kubernetes_e_Infraestructura_como_Código_20260812224304.pptx`, 8 láminas, entregado para esta sesión.

## Objetivo aplicado al proyecto

Empaquetar la base del backend Node.js, desplegarla declarativamente en un clúster local y administrar el namespace mediante Terraform. La funcionalidad académica y las integraciones AWS de los ADR anteriores continúan como trabajo posterior.

## Entregables incorporados

- [Base ejecutable y pruebas HTTP](../../services/api/)
- [Dockerfile multi-stage distroless](../../Dockerfile) y [.dockerignore](../../.dockerignore)
- [Deployment](../../k8s/deployment.yaml), [Service](../../k8s/service.yaml), [Ingress](../../k8s/ingress.yaml), [ConfigMap](../../k8s/configmap.yaml), [HPA](../../k8s/hpa.yaml) y [Kustomization](../../k8s/kustomization.yaml)
- [Terraform raíz remota](../../terraform/main.tf), [módulo](../../terraform/modules/workload/main.tf) y [laboratorio local](../../terraform/lab/main.tf)
- [ADR de plataforma](../ADR/0005-plataforma-k8s.md) y [ruta solicitada por el PPT](../adr/0004-plataforma-k8s.md)
- [Workflow de validación y publicación](../../.github/workflows/platform-s07.yml)
- [Prueba de carga y HPA](../../scripts/verify-hpa.sh), [guía Kubernetes](../../k8s/README.md) y [guía Terraform](../../terraform/README.md)

## Matriz de entrega y evidencias

| Requisito del PPT | Puntos | Implementación | Evidencia de aceptación |
| --- | ---: | --- | --- |
| Dockerfile multi-stage y distroless | 20 | Etapa build con pruebas, runtime nonroot y healthcheck | CI debe construir, iniciar el contenedor y acreditar tamaño < 200 MB |
| Manifiestos completos y válidos | 25 | Cinco objetos y Kustomize, probes, recursos y seguridad | CI ejecuta dry-run de servidor y rollout sobre kind; la ruta de Ingress requiere controlador aparte |
| Terraform aplicable | 20 | Provider, módulo de namespace/Secret ficticio y backend S3 parcial | CI valida raíz remota sin backend y aplica raíz local; backend S3 real pendiente de cuenta/bucket |
| HPA configurado y probado | 15 | CPU 60%, 2–5 réplicas, Job de carga | CI debe acreditar subida y regreso a 2 réplicas con Metrics Server |
| ADR argumentado | 15 | ADR 0005 y referencia 0004 solicitada | Revisión por pares pendiente |
| Puntualidad | 5 | Entrega mediante PR | Evalúa el docente antes del inicio de S08; no se asigna puntaje automáticamente |

La existencia de archivos no acredita por sí sola una ejecución exitosa. Consultar la ejecución del PR en Actions y sus artefactos. La evidencia `kubectl-get-all.txt` es salida real del clúster efímero si el job termina correctamente. La captura de esa terminal debe adjuntarse al README para satisfacer literalmente la lámina 7.

Registro concreto de la preparación: [validaciones y pendientes](../evidencias/s07/README.md).

## Ejecución y evidencias

1. Seguir la [guía de laboratorio](../../k8s/README.md) con Docker, kind, kubectl y Terraform.
2. Ejecutar `bash scripts/verify-hpa.sh` en el contexto `kind-aulaviva`.
3. Conservar `artifacts/hpa-before.txt`, `hpa-during.txt`, `hpa-after.txt`, `top-during.txt`, `kubectl-get-all.txt` y `hpa-result.txt`.
4. Tomar una captura real de `kubectl get all -n equipo-02`, subirla a `docs/evidencias/s07/` e incluirla en el README principal. No utilizar imágenes fabricadas.
5. Publicar GHCR mediante el workflow y conservar `image-digest.txt` y `deploy-ghcr.yaml`. Verificar visibilidad del paquete o configurar credenciales de pull antes de desplegarlo fuera del runner.

## Diferencias frente al ejemplo de las láminas

El ejemplo CrediScore es una FinTech ilustrativa: AulaViva utiliza Node.js, no el servicio de scoring Python. El HPA usa el esquema correcto de `autoscaling/v2`, con `metrics`, `scaleTargetRef` y `target.averageUtilization`. No se copian el digest ficticio `abc...` ni las obligaciones CMF del ejemplo.

Las láminas mencionan Terraform >= 1.6 y S3 con DynamoDB. Esta implementación requiere >= 1.10 para locking nativo en S3 y evita administrar una tabla adicional. La raíz de laboratorio local no reemplaza la validación del state remoto.

La lámina 4 indica una expectativa < 80 MB para su ejemplo Python; la lámina 8 pide verificar < 200 MB para la entrega. CI mide el límite de cierre de 200 MB para Node.js y no declara el umbral de 80 MB como logrado sin medición.

## Pendientes para cerrar la entrega

- Revisar los resultados reales del PR y resolver cualquier fallo.
- Captura real de `kubectl get all` incorporada en README.
- Publicación GHCR y prueba de pull por digest (workflow manual o integración en main).
- Configuración y prueba del backend remoto S3, con lock, bajo una cuenta autorizada del equipo.
- Revisión por un integrante y validación del docente. No se registra aprobación o nota anticipada.

## Próxima sesión

S08 tratará CI/CD y GitOps. El workflow de S07 cubre validación del laboratorio y publicación manual/main, pero no declara Argo CD, Flux, observabilidad o quality gates completos como implementados.
