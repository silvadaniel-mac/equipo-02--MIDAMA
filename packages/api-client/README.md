# Cliente TypeScript de AulaViva

`src/schema.d.ts` se genera desde `api/openapi.yaml` con openapi-typescript 7.13.0. No editarlo a mano. `src/index.ts` conecta esos tipos a openapi-fetch (transporte HTTP tipado).

Desde la raíz: `npm ci`, `npm run api:generate`, `npm run api:typecheck`. El ejemplo compilable está en `examples/usage.ts`. Los tipos garantizan rutas, parámetros, cuerpos y respuestas en compilación, no validan las respuestas en runtime. El token proviene del proveedor de identidad y nunca se almacena en el SDK.
