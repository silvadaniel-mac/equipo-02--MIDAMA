# AulaViva · Equipo MIDAMA

Plataforma educativa SaaS multi-tenant con tutor de inteligencia artificial, orientada a colegios. Proyecto de aula de Taller de Ingeniería de Software.

**[Índice de documentación](docs/README.md)** · **[Avance S07](docs/sesiones/s07-contenedores-kubernetes-iac.md)** · **[Charter y equipo](CHARTER.md)**

## Avances del proyecto

| Área | Documentación o implementación |
| --- | --- |
| Alcance y requisitos | [Charter](CHARTER.md), [backlog](docs/backlog.md), [impact map](docs/impact-map.md) |
| Arquitectura | [C4](docs/c4/README.md), [decisiones ADR](docs/ADR/README.md) |
| API S05 | [Guía](docs/api/README.md), [OpenAPI 3.1](api/openapi.yaml), [versionado](docs/api/versioning-policy.md), [cliente TypeScript](packages/api-client/README.md) |
| Datos y eventos S06 | [Índice del modelo](docs/data/README.md) |
| Contenedores e IaC S07 | [Dockerfile](Dockerfile), [Kubernetes](k8s/README.md), [Terraform](terraform/README.md), [ADR plataforma](docs/ADR/0005-plataforma-k8s.md) |

## Ejecutar la base del servicio S07

Con Node.js 24:

```bash
node --test services/api/server.test.mjs
node services/api/server.mjs
```

En otra terminal:

```bash
curl http://localhost:8080/
curl http://localhost:8080/healthz
curl http://localhost:8080/readyz
```

Esta es la base operativa del laboratorio. Los endpoints de negocio definidos en OpenAPI aún no están implementados y responden `501` bajo `/api/`. No incluye autenticación, base de datos ni tutor IA funcional.

Para construir y desplegar el contenedor en kind, seguir la [guía S07](k8s/README.md).

## Validar el contrato S05

```bash
npm ci
npm run api:check
```

Ejecutar `npm run api:mock` en una terminal y `npm run api:examples` en otra. `npm run api:docs` genera la referencia Redoc.

[Swagger UI del contrato en main](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/silvadaniel-mac/equipo-02--MIDAMA/main/api/openapi.yaml).

## Evidencias S07

El workflow `Plataforma S07` ejecuta pruebas del servicio, build distroless, validación de Terraform y laboratorio kind con HPA. Sus resultados y archivos se consultan en [GitHub Actions](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions).

**Captura solicitada por el PPT:** pendiente de adjuntar una captura real de `kubectl get all -n equipo-02`. Los logs automáticos se guardan como artefactos de Actions, pero no sustituyen esa captura. Estado detallado en la [matriz de entrega](docs/sesiones/s07-contenedores-kubernetes-iac.md#matriz-de-entrega-y-evidencias).
