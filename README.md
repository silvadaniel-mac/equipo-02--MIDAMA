# AulaViva

**Plataforma educativa SaaS multi-tenant del equipo MIDAMA**  
Proyecto de aula de Taller de Ingeniería de Software. Integra el diseño de gestión académica, contenidos, evaluaciones y tutor de inteligencia artificial.

[Documentación del proyecto](docs/README.md) · [Entrega S07](docs/sesiones/s07-contenedores-kubernetes-iac.md) · [Equipo y alcance](CHARTER.md)

## Avances por sesión

| Etapa | Trabajo incorporado | Acceso |
| --- | --- | --- |
| Definición | Propósito, roles, requisitos y backlog | [Charter](CHARTER.md) · [Backlog](docs/backlog.md) · [Impact map](docs/impact-map.md) |
| Arquitectura | Modelo C4, decisiones técnicas y servicios cloud | [Diagramas C4](docs/c4/README.md) · [ADRs](docs/ADR/README.md) |
| S05 · Contrato API | OpenAPI 3.1, cliente TypeScript, ejemplos y pruebas | [Guía de API](docs/api/README.md) · [Contrato](api/openapi.yaml) |
| S06 · Datos y eventos | Bounded Contexts, DER y catálogo de eventos | [Modelo de datos](docs/data/README.md) |
| S07 · Plataforma | Contenedor distroless, Kubernetes, HPA y Terraform | [Guía de entrega](docs/sesiones/s07-contenedores-kubernetes-iac.md) |

## S07 · Contenedores, Kubernetes e IaC

La entrega incorpora una base ejecutable del backend Node.js para comprobar construcción, despliegue y escalamiento en un clúster local.

| Componente | Implementación |
| --- | --- |
| Docker | Build multi-stage, runtime distroless, usuario no root y healthcheck |
| Kubernetes | Deployment, Service, Ingress, ConfigMap, probes y HPA de 2 a 5 réplicas |
| Terraform | Módulo de namespace y Secret ficticio, raíz local y configuración de backend S3 |
| Automatización | Pruebas HTTP, validación de infraestructura, laboratorio kind y prueba de carga |
| Decisión técnica | [ADR de plataforma](docs/ADR/0005-plataforma-k8s.md), con alternativas y justificación |

**Guías:** [Docker y Kubernetes](k8s/README.md) · [Terraform](terraform/README.md) · [Evidencias y validaciones](docs/evidencias/s07/README.md)

El servicio S07 expone salud y disponibilidad. Los endpoints académicos del contrato S05, la persistencia y el tutor IA todavía requieren implementación. Las rutas `/api/` responden `501` para identificar ese alcance.

## Inicio rápido

Con Node.js 24, ejecutar desde la raíz del proyecto:

```bash
npm ci
npm run platform:test
node services/api/server.mjs
```

En otra terminal:

```bash
curl http://localhost:8080/
curl http://localhost:8080/healthz
curl http://localhost:8080/readyz
```

Para ejecutar el contenedor en kind, seguir la [guía del laboratorio](k8s/README.md).

## Validación del contrato API

```bash
npm run api:check
```

Para probar los ejemplos, ejecutar `npm run api:mock` en una terminal y `npm run api:examples` en otra. `npm run api:docs` genera la documentación Redoc.

## Organización del repositorio

| Ruta | Contenido |
| --- | --- |
| `api/` | Contrato OpenAPI y ejemplos HTTP |
| `services/api/` | Servicio ejecutable S07 y pruebas |
| `packages/api-client/` | Cliente TypeScript generado desde el contrato |
| `k8s/` | Manifiestos Kubernetes y carga de laboratorio |
| `terraform/` | Infraestructura como código y módulo reutilizable |
| `scripts/` | Ejemplos, despliegue por digest y verificación HPA |
| `docs/` | Arquitectura, requisitos, sesiones y evidencias |
| `.github/workflows/` | Validaciones automáticas del proyecto |

## Estado de validación

Los resultados de cada commit se consultan en [GitHub Actions](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions). Una cruz roja indica que una ejecución falló; un círculo amarillo, que sigue pendiente o en curso; una marca verde, que terminó correctamente. Los resultados antiguos permanecen en el historial aunque una ejecución posterior corrija el problema.

La [matriz S07](docs/sesiones/s07-contenedores-kubernetes-iac.md#matriz-de-entrega-y-evidencias) distingue los archivos implementados de sus evidencias de ejecución. Para cerrar la entrega se debe incorporar al README una captura real de `kubectl get all -n equipo-02`, conservar el resultado de HPA, publicar GHCR por digest y verificar el backend remoto cuando el equipo disponga de la cuenta correspondiente.


## Sesión 08: CI/CD y GitOps

Pipeline con quality gates, publicación GHCR por SHA y laboratorio Argo CD. Consultar [implementación y pasos de conexión](docs/sesiones/s08-ci-cd-gitops.md) y [ADR 0005](docs/adr/0005-gitops-strategy.md). El paquete exportable del repositorio separado está en [gitops/](gitops/). La creación del repo externo y sus protecciones requiere al dueño de la cuenta.

## Sesión 09: DevSecOps y shift-left

[Guía S09](docs/sesiones/s09-devsecops.md) · [Modelo STRIDE](docs/threat-model.md) · [Evidencias](docs/evidencias/s09/README.md).

El workflow S08 llama a `.github/workflows/security.yml`. Sus jobs `sast`, `sca` y `secrets` corren en paralelo. `build-and-push` depende también de `security`: un fallo impide construir/publicar/promover. SAST combina `p/owasp-top-ten`, las reglas previas y dos reglas propias en `.semgrep/`, con pruebas positivas y negativas. Trivy filesystem incluye dependencias de desarrollo y bloquea HIGH/CRITICAL con parche disponible. El inventario CycloneDX se publica como `sbom.json` dentro del artefacto `s09-sca-sbom-<SHA>`. Gitleaks revisa todo el historial alcanzable con checkout completo.

### Cómo re-triar hallazgos y solicitar excepciones VEX

1. Abrir el run del PR y descargar los reportes `s09-sast-*`, `s09-sca-sbom-*` y `s09-secrets-*`. Registrar regla/CVE, paquete y versión, ruta, commit y evidencia. Nunca pegar un secreto real en un issue.
2. Evaluar exposición desde red, alcance al código vulnerable, impacto en datos de menores y uso en runtime o herramientas de CI. Priorizar Critical < 7 días, High < 30 y Medium < 90. Revocar de inmediato cualquier credencial real.
3. Preferir actualización, eliminación de la dependencia o corrección del código. Ejecutar nuevamente los tres controles sobre el nuevo SHA y adjuntar resultados. Los hallazgos sin parche se revisan igualmente aunque `--ignore-unfixed` no los bloquee.
4. Si un CVE no aplica, abrir un PR con un documento OpenVEX bajo `docs/security/`, usando la [plantilla](docs/security/vex-template.json). Completar producto/versión, identificador de vulnerabilidad, estado, justificación, evidencia técnica, responsable y vencimiento. Un mantenedor distinto del autor debe aprobar. Proponer máximo 30 días para High, 7 para Critical, sin superar el SLA.
5. **El VEX documentado no desactiva automáticamente el gate.** Cualquier excepción al escáner debe ser limitada al CVE y componente exactos, revisada en ese mismo PR y con control de expiración automatizado antes de activarse. No se incorporan exclusiones globales ni una baseline para esconder hallazgos. Para falsos positivos de SAST, corregir la regla mediante PR con un test de regresión, sin `nosec` silencioso.

El administrador debe activar protección de `main`, revisión de PR y checks obligatorios `security / sast`, `security / sca`, `security / secrets`, además de los existentes. Confirmar los nombres exactos después del primer run. Crear una cuenta Semgrep gratuita permite gestionar reglas en su plataforma, pero este escaneo usa reglas públicas sin token: no se afirma haber creado o vinculado una cuenta.


## Sesión 10: DevSecOps II y supply chain

[Guía S10](docs/sesiones/s10-supply-chain.md) · [ADR 0006](docs/adr/0006-supply-chain.md) · [Evidencias](docs/evidencias/s10/README.md) · [Workflow S10](.github/workflows/supply-chain-s10.yml).

El pipeline conserva los controles S09 y agrega Checkov sobre Terraform, Trivy sobre la imagen final, firma Cosign keyless, attestation SLSA y verificación por identidad exacta. Despliega esa imagen por digest en kind, exige firma/provenance con Kyverno y comprueba tres reglas Falco con syscalls reales. ZAP baseline analiza el staging y bloquea Medium/High. Los controles negativos prueban el rechazo de IaC insegura, una imagen sin firma y una identidad ajena. Cada alerta Falco High genera un registro de incidente.

El staging es temporal y desaparece con el runner. Los endpoints académicos aún no implementados responden 501. El análisis no acredita seguridad de flujos que todavía no existen. La matriz de la consigna y los resultados del run se mantienen en los enlaces anteriores.
