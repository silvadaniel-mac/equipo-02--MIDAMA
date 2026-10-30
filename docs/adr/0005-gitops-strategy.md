# ADR 0005: CI con GitHub Actions y reconciliación pull con Argo CD

- Estado: aceptado para laboratorio S08. Conexión al repositorio externo pendiente de habilitación.
- Fecha: 2026-10-29
- Equipo: MIDAMA, AulaViva
- Alcance: plataforma HTTP de S07. El servidor todavía responde 501 a los casos de negocio del contrato OpenAPI.

## Contexto

S07 aporta Dockerfile multi-stage, ejecución nonroot, probes y manifiestos Kubernetes. Necesitamos bloquear cambios defectuosos antes de construir una imagen y poder rastrear qué commit ejecuta el clúster. El equipo trabaja con GitHub y un único servicio Node.js, sin una infraestructura Azure o GitLab existente. La sesión solicita un repo GitOps independiente, dos PR coordinados, una ejecución verde en main y evidencia Synced/Healthy.

## Decisión

Usar GitHub Actions. Cada PR ejecuta lint ESLint, formato Prettier, pruebas HTTP con cobertura de líneas del servidor >=70%, contrato OpenAPI y Semgrep. Una matriz Node 22/24 verifica compatibilidad. Un fallo bloquea build-and-push mediante needs, sin continue-on-error. Semgrep usa reglas ERROR versionadas para código dinámico, shell, TLS deshabilitado y credenciales literales. Son un conjunto inicial acotado, no un análisis completo de seguridad.

La imagen distroless se construye, prueba y escanea con Trivy. HIGH/CRITICAL bloquean incluso si no existe corrección. En main se publica a GHCR con tag igual al SHA completo y se firma mediante Cosign/OIDC. Dev utiliza el digest, que evita cambios de contenido bajo una etiqueta.

Elegir reconciliación pull con Argo CD. CI publica artefactos y abre un PR en `miguelbriceno-sys/equipo-02-gitops`. Argo observa main de ese repo. CI no recibe kubeconfig del clúster de desarrollo o producción. El único kubectl de Actions corresponde al kind efímero de pruebas.

Elegir Argo CD frente a Flux por su vista de aplicaciones, salud y diferencias, útil para la demostración y el equipo. Flux requiere menos componentes y es una buena alternativa si se prioriza operación exclusivamente por CLI. Push con kubectl sería más corto, pero expondría acceso al clúster en CI y exigiría mecanismos adicionales para detectar drift.

Mantener base Kustomize con Deployment y Service. Overlays dev/prod cambian namespace, réplicas e imagen. No exportar los placeholders ni la carga sintética de S07. Argo usa `selfHeal` y `prune`, restringido a los namespaces del proyecto. Se revisan las eliminaciones en cada PR.

Adoptar GitHub Flow: ramas cortas feature/*, PR y main desplegable. El propietario debe activar dos revisores, checks requeridos, revisión de CODEOWNERS, descarte de aprobaciones antiguas y prohibición de force push. CODEOWNERS por sí solo no activa estas restricciones. El token actual permite push, pero no administración: las protecciones todavía no están verificadas.

Producción utiliza otro PR que copia el digest ya probado de dev a prod. Ese PR requiere dos aprobaciones. Argo reconcilia automáticamente después del merge autorizado. No promocionar producción por el solo merge del código de aplicación.

## Consecuencias

- Cada imagen se relaciona con un commit y cada despliegue con un PR de configuración.
- Un revert del cambio GitOps restaura el digest anterior. `rollout undo` directo generaría drift que selfHeal revertiría.
- Una GitHub App limitada al repo GitOps debe permitir Contents y Pull requests de escritura. Actions genera tokens temporales. GITHUB_TOKEN del repo app no basta para escribir otro repo.
- GHCR debe permitir lectura al clúster. Usar paquete público para este laboratorio, o un imagePullSecret gestionado fuera de Git en un entorno privado. No almacenar credenciales en YAML.
- Argo añade componentes y consumo de recursos. Hay que mantener su versión, RBAC y acceso administrativo.
- El kind de Actions desaparece al terminar el job. La captura acredita ese laboratorio, no un servicio persistente de producción.
- Mientras no se cree el repo externo, CI exporta un paquete GitOps resuelto por digest y declara promoción externa pendiente. No equivale a un despliegue automático entre repositorios.

## Validación y límites

El job gitops-lab instala Argo CD real, reconcilia el bundle provisional ubicado en app/gitops, exige Synced/Healthy, verifica por HTTP el SHA del binario y prueba selfHeal alterando réplicas de 1 a 2 para observar su vuelta a 1. Guarda JSON, logs y capturas reales.

La verificación final pendiente requiere: crear el repo separado con el script bootstrap, fusionar su PR, configurar la GitHub App, instalar las Applications definitivas y fusionar un PR app. Después, aprobar el PR automático de dev y comparar `status.sync.revision`, digest del Deployment y `release` HTTP. No confundir la prueba provisional con esta aceptación final.

## Estrategia de entrega

Se adopta RollingUpdate con maxUnavailable=0 para el mínimo de S08. Canary con Argo Rollouts es bonus y se pospone: todavía no existen métricas de negocio ni reglas de análisis que permitan justificar un rollback automático. No se presenta un YAML sin ejecutar como canary verificado.

## Referencias

- https://docs.github.com/en/actions/use-cases-and-examples/publishing-packages/publishing-docker-images
- https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/
- https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- https://nodejs.org/learn/test-runner/collecting-code-coverage

## Relación con ADR anteriores

El proyecto contiene decisiones previas con numeración 0005 en `docs/ADR/`. Este archivo conserva la ruta y el nombre exactos pedidos por S08, sin sobrescribir esas decisiones de S07.
