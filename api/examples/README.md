# Ejemplos ejecutables

Terminal 1 desde la raíz: `npm ci && npm run api:mock`.

Terminal 2: `npm run api:examples`. Los cuatro JSON son casos ejecutados por `scripts/run-examples.mjs`, que valida status, campos y cabecera de trazabilidad. Para otro entorno: `API_BASE_URL=https://tu-api API_TOKEN=token npm run api:examples`. Los POST crean datos: usar solo un entorno de prueba autorizado.

Prism valida la estructura y devuelve los ejemplos del contrato. El token ficticio sirve solo para el mock. No verifica JWT, roles, aislamiento, retención de idempotencia ni ejecuta la IA. Estas garantías requieren pruebas de integración sobre el backend futuro.
