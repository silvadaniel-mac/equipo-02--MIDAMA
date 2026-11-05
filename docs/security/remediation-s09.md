# Remediación S09

Responsable: equipo MIDAMA. El primer run del PR #7 bloqueó correctamente por CVE-2026-73231.

## Corrección

Se elimina @stoplight/prism-cli y su cadena http-spec / postman-collection / @faker-js/faker 5.5.3. El mock usa ahora @scalar/mock-server 0.21.0 con Faker 10.6.0, versión corregida. Se mantiene el comando npm run api:mock, el contrato OpenAPI, el puerto 4010 y la escucha solo en 127.0.0.1.

El wrapper genera X-Trace-Id cuando el mock no lo incluye. No implementa operaciones académicas reales. La validación de autenticación, esquemas e idempotencia se mantiene activa. Node mínimo: 22.19.0, conforme a los requisitos de Scalar.

Las siete pruebas de regresión verifican los cuatro ejemplos existentes y el rechazo de solicitudes sin autenticación, con cuerpo inválido y sin Idempotency-Key. npm audit se ejecuta con dependencias de desarrollo. Trivy conserva el gate HIGH/CRITICAL con parche y exit-code 1.

No se añadieron ignores, VEX de exclusión, continue-on-error ni filtros para ocultar Faker. lodash conserva el override 4.18.1 y YAML permanece en 2.9.1. El downgrade de Prism se descartó porque añadía otros CVE.

## Cierre

Validar en GitHub Actions los tres controles sobre el nuevo SHA y descargar su SBOM. Las evidencias del primer run fallido permanecen como historial del hallazgo. La protección de main requiere al administrador del repositorio.
