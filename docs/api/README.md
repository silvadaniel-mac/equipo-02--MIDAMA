# Sesión 05: contrato de AulaViva

## Documentación viva accesible

[Ver Swagger UI del contrato en la rama S05](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/silvadaniel-mac/equipo-02--MIDAMA/feat/s05-openapi-contract/api/openapi.yaml).

El enlace usa el Swagger UI público y carga directamente el YAML de esta rama pública; no requiere desplegar un backend. Después del merge, cambiar el segmento de rama por `main`. Para generar documentación autocontenida local: `npm run api:docs` crea `docs/api/reference.html`; CI la adjunta como artefacto.

## Entregables y verificación

| Requisito | Evidencia |
| --- | --- |
| OpenAPI 3.1 | `api/openapi.yaml` |
| Al menos 5 endpoints | 7 operaciones en 5 rutas: contenido GET/POST, notas GET/POST, informe GET, tutor POST, evaluación POST |
| Schemas reutilizables | 12 schemas para entradas, salidas, páginas y Problem |
| Path/query/header | schoolId, courseId, studentId; limit/cursor/subject; Idempotency-Key |
| Seguridad | bearerAuth JWT y política de permisos/aislamiento |
| Respuestas | 200/201, 400/401/403/404/409/422/429/503 |
| RFC 7807 | Problem con application/problem+json y trazabilidad |
| Ejemplos por operación | Request de POST y respuesta exitosa por operación en YAML; GET sin cuerpo usa ejemplos de parámetros |
| Ejemplos ejecutables | 4 JSON y runner en `api/examples/` |
| Spectral | `.spectral.yaml`, summary obligatorio y kebab-case |
| Cliente generado | `packages/api-client/src/schema.d.ts`, generador reproducible y transporte openapi-fetch |
| Versionado | `docs/api/versioning-policy.md` |
| Bonus | Prism, pruebas y workflow CI |

## Límites y próximos pasos S06

Esta entrega diseña el contrato, no implementa el backend. JWT, permisos, aislamiento, idempotencia persistente y generación IA están especificados para su implementación posterior. El mock no demuestra estas garantías.

El modelo preliminar y lectura de Outbox, Saga y CQRS están en [preparacion-s06.md](preparacion-s06.md). La PPT pide backlog y C4 L2 aprobados como prerrequisitos: existen en el repositorio, pero la aprobación humana no se puede inferir de los archivos.
