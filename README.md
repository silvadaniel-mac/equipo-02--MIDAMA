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
