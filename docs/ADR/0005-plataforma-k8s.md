# ADR 0005 · Plataforma Kubernetes e infraestructura como código

- **Proyecto:** AulaViva, equipo MIDAMA.
- **Sesión:** S07.
- **Estado:** Propuesto para revisión del equipo.
- **Alcance:** laboratorio académico local; no autoriza infraestructura AWS de pago.

## Contexto

El backend de AulaViva está diseñado como monolito modular Node.js y el Tutor IA como componente separado. S05 definió el contrato y S06 el modelo de datos/eventos, pero el repositorio todavía no implementa los casos académicos. S07 necesita una unidad ejecutable que permita probar empaquetado, rollout y escalamiento sin simular esos casos como terminados.

El C4 y ADR 0003 sitúan el backend en ECS Fargate. El uso de Kubernetes en esta sesión es una plataforma de laboratorio y una alternativa evaluada. No sustituye automáticamente la decisión cloud ni implica contratar EKS.

## Decisión

1. **kind** como distribución local sobre Docker. Es reproducible en el computador del equipo y en GitHub Actions. El clúster se llama `aulaviva` y el namespace `equipo-02`.
2. **Node.js 24 con distroless Debian 13 nonroot** como runtime. El build usa Node 24 sobre la misma familia Debian y ejecuta chequeo de sintaxis y pruebas. La etapa final copia únicamente `server.mjs`; no instala npm, shell ni herramientas de depuración.
3. **Kustomize** para los cinco manifiestos exigidos. La composición por recursos alcanza para un servicio y evita introducir plantillas Helm innecesarias. Terraform es el único dueño del namespace y del Secret ficticio; Kustomize administra la aplicación.
4. **Terraform** con provider Kubernetes y módulo reutilizable. La raíz `terraform/` exige backend S3 remoto con cifrado y locking nativo `use_lockfile`; requiere Terraform >= 1.10. La raíz `terraform/lab/` usa el mismo módulo con estado local ignorado por Git para pruebas sin cuenta AWS. No administrar el mismo namespace con ambas raíces.
5. **HPA por CPU**, objetivo 60%, mínimo 2 y máximo 5 réplicas, requests de 100m y límites de 500m. Metrics Server es requisito. Latencia custom requiere un adaptador de métricas que no se implementa en S07; no afirmamos escalamiento por latencia.
6. **GHCR por digest** para distribución. El workflow manual o el push a main publica el SHA del commit y entrega el digest real y manifiesto resuelto como artefactos. `scripts/deploy-s07.sh` rechaza tags y exige `@sha256:`. El tag `:local` se limita al laboratorio kind con la imagen cargada localmente.

## Seguridad y configuración

El contenedor corre como UID/GID 65532, con filesystem de solo lectura, sin capabilities, sin escalamiento de privilegios y sin token del ServiceAccount. El namespace exige el perfil Pod Security `restricted`. ConfigMap contiene configuración no sensible y Terraform crea un Secret con texto ficticio, sin credenciales reales.

Los probes `/healthz` y `/readyz` verifican el proceso y disponibilidad del scaffold, no conectividad con RDS o el Tutor IA todavía inexistentes. La carga `/lab/work` está apagada por defecto y solo el script de prueba la activa temporalmente en kind.

El Ingress define HTTP local para `aulaviva.local` y exige un controlador de clase `nginx` si se prueba esa ruta. Producción requiere un controlador mantenido, DNS, TLS y autorización apropiada antes de exponer la API.

No se versionan `.tfstate`, planes ni credenciales. S3 requiere un bucket preexistente privado y versionado y permisos mínimos sobre el state y su `.tflock`. Un state por ambiente y dominio de cambio. El backend remoto no se considera probado hasta configurar una cuenta real y verificar adquisición del lock.

## Alternativas y trade-offs

| Alternativa | Ventaja | Decisión para S07 |
| --- | --- | --- |
| minikube | Add-ons integrados y experiencia local sencilla | Válido, pero kind facilita usar el mismo flujo en CI |
| k3d / k3s | Ligero y rápido | Válido; se prefiere Kubernetes upstream de kind para el ejercicio |
| EKS | Kubernetes administrado en AWS | Posible evolución; costos e IAM innecesarios para el laboratorio |
| ECS Fargate | Alineado con ADR 0003 y menor operación | Sigue como propuesta cloud vigente hasta revisión explícita |
| Helm | Charts parametrizables y releases | Reservado para múltiples servicios o empaquetado reutilizable |
| Pulumi | Lenguajes de programación y pruebas de IaC | Terraform satisface el ejercicio con HCL y un módulo pequeño |
| CloudFormation | Integración nativa AWS | No es adecuado para administrar este laboratorio Kubernetes local |
| Node slim como runtime | Depuración directa y npm disponible | Se prefiere distroless para reducir herramientas y superficie de ataque |

## Consecuencias

Se gana reproducibilidad y se pueden observar réplicas, requests y límites con una aplicación pequeña. A cambio, kind depende de Docker y Metrics Server requiere una configuración de certificados específica del laboratorio. Distroless dificulta depuración interactiva; se utilizarán logs y contenedores de diagnóstico cuando corresponda.

Las bases Docker se seleccionan por versión de runtime y distribución, pero sus tags pueden cambiar: el workflow fija la imagen publicada por digest y documenta el tamaño real. Fijar también los digest de las bases por build-args es una mejora posterior para congelar completamente la cadena de build. No se promete un tamaño menor a 80 MB sin medir. El criterio de cierre de la lámina 8 es **menor a 200 MB**, que comprueba CI.

## Validación y pendientes

[Guía operativa](../../k8s/README.md) · [Terraform](../../terraform/README.md) · [Matriz S07](../sesiones/s07-contenedores-kubernetes-iac.md).

La aprobación por pares, la captura real de terminal, la publicación GHCR y la prueba del backend S3 se registran con evidencia, no solo por existir la configuración.

## Referencias técnicas

- [Distroless oficial](https://github.com/GoogleContainerTools/distroless)
- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [HPA autoscaling/v2](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/)
- [Backend S3 de Terraform](https://developer.hashicorp.com/terraform/language/backend/s3)
