# S08: CI/CD y GitOps de AulaViva

## Componentes

| Requisito | Implementación | Evidencia verificable |
|---|---|---|
| quality, build-and-push, promote | `.github/workflows/ci.yml` | GitHub Actions de S08 |
| Lint y formato | ESLint y Prettier bloqueantes | job quality, matriz Node 22/24 |
| Cobertura >=70% | Node test runner, incluye solo server.mjs | artifacts/coverage.txt |
| SAST | Semgrep con reglas ERROR versionadas | artifacts/semgrep.json |
| SCA | npm audit --omit=dev --audit-level=high | quality, sin dependencias runtime actualmente |
| Imagen escaneada y firmada | Trivy HIGH/CRITICAL y Cosign OIDC | artifacts/trivy.json, GHCR |
| Imagen por commit | GHCR tag SHA completo, despliegue por digest | artifacts/image-digest.txt |
| Kustomize separado por ambiente | gitops/base, overlays/dev y prod | renders y paquete exportable |
| Argo CD Synced/Healthy | kind efímero, Application de laboratorio | artifacts/argocd-synced-healthy.png y JSON |
| Drift | escala 1 a 2 fuera de Git, selfHeal vuelve a 1 | artifacts/self-heal.txt |
| ADR 0005 | docs/adr/0005-gitops-strategy.md | contexto, decisión, consecuencias |
| Repo separado y segundo PR | script bootstrap preparado | pendiente de creación del repo y autenticación |
| Promoción automática por PR | GitHub App y script promote | pendiente de configuración externa |
| Dos revisores y protección | CODEOWNERS y procedimiento inferior | pendiente de administrador |
| ZAP baseline staging | reservado a S09 | todavía no bloqueante |
| Canary, bonus | decisión de postergar | no implementado |

El laboratorio provisional apunta a `gitops/overlays/dev` en el repositorio app. La configuración definitiva dentro del paquete apunta al repositorio separado. El modo provisional no satisface por sí solo el requisito de dos repositorios.

## Ejecutar comprobaciones locales

Requisitos: Node 22/24, Python 3.12 y Semgrep 1.183.0.

```bash
npm ci
npm run ci:quality
python -m pip install semgrep==1.183.0
semgrep scan --config .semgrep.yml --error --strict --metrics=off services/api scripts
bash -n scripts/*s08.sh
```

## Completar la separación GitOps

1. Con `gh` autenticado y sin un repo existente con ese nombre, ejecutar:

   ```bash
   bash scripts/bootstrap-gitops-s08.sh miguelbriceno-sys/equipo-02-gitops
   ```

2. Revisar y fusionar el PR que crea base, overlays y Applications. El tag `bootstrap` identifica una imagen aún no promovida, no se debe desplegar tal cual. Usar el digest del artefacto `s08-promotion-<SHA>`.
3. El administrador crea una GitHub App limitada al repo GitOps con Contents y Pull requests: read/write. Instalarla solo en ese repo. Configurar en el repo app:
   - Variables: `GITOPS_REPOSITORY=miguelbriceno-sys/equipo-02-gitops`, `GITOPS_OWNER=miguelbriceno-sys`, `GITOPS_REPO_NAME=equipo-02-gitops`, `GITOPS_APP_ID=<id>`.
   - Secret: `GITOPS_APP_PRIVATE_KEY`, clave privada de la App. No pegar claves en el chat ni en Git.
4. Configurar GHCR como público para el laboratorio académico o provisionar lectura privada desde el clúster con un gestor de secretos.
5. En un clúster de desarrollo, instalar Argo CD con el manifiesto oficial versionado y aplicar:

   ```bash
   kubectl apply -n argocd -f argocd/project.yaml
   kubectl apply -n argocd -f argocd/application-dev.yaml
   kubectl apply -n argocd -f argocd/application-prod.yaml
   ```

   Ejecutar desde el repo GitOps después de sustituir ambos `bootstrap` por digests publicados. No instalar en producción real sin preparar su acceso y políticas.

6. El dueño de cada repo activa protección de main: Require pull request, 2 approvals, Dismiss stale approvals, Require code owner review, Require conversation resolution, sin bypass ni force push. En app exigir quality Node 22/24, sast, build-and-push y gitops-lab. En GitOps exigir manifests. Los jobs promote posteriores al merge no pueden ser checks previos de un PR.
7. Fusionar un PR app. CI publica SHA, abre PR GitOps dev y espera revisión. Al fusionar ese PR, Argo detecta el nuevo estado. Verificar:

   ```bash
   kubectl get application aulaviva-dev -n argocd -o jsonpath='{.status.sync.status} {.status.health.status} {.status.sync.revision}'
   kubectl get deployment aulaviva-api -n aulaviva-dev -o jsonpath='{.spec.template.spec.containers[0].image}'
   ```

   Por port-forward consultar `/` y comparar `release` con el SHA de aplicación.

## Rollback y producción

Crear un PR que revierta el digest de dev o prod al digest anterior probado. Conservar las dos revisiones de prod. Tras merge, esperar Synced/Healthy y verificar la raíz HTTP. No cambiar tags de imágenes ya publicadas.

## Comparación de plataformas

GitHub Actions reutiliza repositorios y revisiones del equipo y permite publicar GHCR sin PAT. GitLab CI integra registry y pipelines, pero requeriría migrar o duplicar repositorios. Azure DevOps conviene a equipos con organización Azure y sus service connections, ausentes en este proyecto. Se eligió GitHub Actions por integración con el trabajo existente.

## Gates hoy y S09

Hoy: ESLint, Prettier, 70% de líneas del servidor, contrato OpenAPI, Semgrep inicial, SCA runtime, Trivy, smoke HTTP y reconciliación kind. Para S09: ampliar reglas SAST de fuentes confiables, escaneo de secretos con alcance de historial, SBOM publicado y gate DAST ZAP sobre staging. El SCA runtime no evalúa las dependencias de herramientas de desarrollo. Ningún gate actual usa continue-on-error.

## DORA

Registrar frecuencia de despliegue desde merges de PR GitOps. Lead time: timestamp del commit app a primer Healthy del digest. Change failure rate: releases con rollback/incidente sobre releases totales. MTTR: inicio de incidente a primer Healthy restaurado. No hay suficientes releases para calcular valores históricos.

## Entorno efímero

El clúster kind se elimina al finalizar Actions. Para mostrarlo en vivo, ejecutar el mismo workflow o repetir el laboratorio en una máquina con Docker/kind/kubectl. Las capturas solo contienen información del trabajo y no llevan textos de generación.

## Corrección del laboratorio S07

La última ejecución de main superó el tiempo del Job de carga después de acreditar el aumento de réplicas. Se acota la carga a 120 segundos y se termina explícitamente el proceso Node tras recoger todas las peticiones. Se mantiene el fallo ante errores HTTP y la comprobación de subida y bajada del HPA. La corrección se valida en el workflow Plataforma S07.
