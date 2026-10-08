# AulaViva

Plataforma educativa SaaS con inteligencia artificial orientada a colegios.

## Documentación arquitectónica

- [C4 nivel 1](docs/c4/l1-context.puml)
- [C4 nivel 2](docs/c4/l2-container.puml)
- [ADR 0002](docs/ADR/0002-estilo-arquitectonico.md)
- [Backlog](docs/backlog.md)

## Sesión 05: API contract-first

[Guía y matriz de requisitos](docs/api/README.md) · [Contrato OpenAPI 3.1](api/openapi.yaml) · [Versionado](docs/api/versioning-policy.md) · [Cliente TypeScript](packages/api-client/README.md).

Con Node.js 24: `npm ci` y `npm run api:check`. Ejecutar `npm run api:mock` en una terminal y `npm run api:examples` en otra. `npm run api:docs` genera la referencia Redoc.

[Documentación viva Swagger UI](https://petstore.swagger.io/?url=https://raw.githubusercontent.com/silvadaniel-mac/equipo-02--MIDAMA/feat/s05-openapi-contract/api/openapi.yaml).
