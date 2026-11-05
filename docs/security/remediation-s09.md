# Remediación S09

Responsable: equipo MIDAMA. El primer run del PR #7 bloqueó correctamente por CVE-2026-73231.

## Corrección

Se elimina @stoplight/prism-cli y su cadena http-spec / postman-collection / @faker-js/faker 5.5.3. El mock usa ahora @scalar/mock-server 0.21.0 con Faker 10.6.0, versión corregida. Se mantiene el comando npm run api:mock, el contrato OpenAPI, el puerto 4010 y la escucha solo en 127.0.0.1.

El wrapper genera X-Trace-Id cuando el mock no lo incluye. No implementa operaciones académicas reales. La validación de autenticación, esquemas e idempotencia se mantiene activa. Node mínimo: 22.19.0, conforme a los requisitos de Scalar.

Las siete pruebas de regresión verifican los cuatro ejemplos existentes y el rechazo de solicitudes sin autenticación, con cuerpo inválido y sin Idempotency-Key. npm audit se ejecuta con dependencias de desarrollo. Trivy conserva el gate HIGH/CRITICAL con parche y exit-code 1.

No se añadieron ignores, VEX de exclusión, continue-on-error ni filtros para ocultar Faker. lodash conserva el override 4.18.1 y YAML permanece en 2.9.1. El downgrade de Prism se descartó porque añadía otros CVE.

## Cierre

Validar en GitHub Actions los tres controles sobre el nuevo SHA y descargar su SBOM. Las evidencias del primer run fallido permanecen como historial del hallazgo. La protección de main requiere al administrador del repositorio.

## Imagen del contenedor: CVE-2026-76844

El commit e53f912 obtuvo SAST, SCA y secretos aprobados en el run 42119854334. El contrato API y calidad Node22/24 también pasaron. El siguiente gate, Trivy de imagen, detectó CVE-2026-76844 HIGH en zlib1g 1:1.3.dfsg+really1.3.1-1+b1, sin FixedVersion para Debian13. El artefacto remoto trivy.json confirma el hallazgo; gitops-lab se omitió por dependencia.

El runtime se compone ahora sobre Distroless base-nossl Debian13 nonroot. Del runtime oficial Node24 se copian Node, su licencia, libstdc++ y libgcc con sus archivos originales de inventario dpkg y las licencias GCC. La base mínima conserva glibc, certificados y zonas horarias. No se incluyen OpenSSL, zlib1g ni libzstd del sistema: el binario Node oficial enlaza sus propias implementaciones de TLS y compresión. No se elimina inventario de paquetes instalados ni se cambia la política del escáner.

La composición local ejecutó correctamente Node24.22.2, un ciclo gzip/gunzip, creación de contexto TLS y SHA256. Trivy rootfs 0.76.2 no encontró HIGH/CRITICAL, incluyendo vulnerabilidades sin corrección. El smoke del workflow repite estas comprobaciones dentro del contenedor antes del escaneo completo de imagen. El resultado local no sustituye la evidencia de construcción y escaneo en GitHub.

Se mantiene UID/GID65532, el healthcheck, filesystem de solo lectura y el gate de imagen HIGH/CRITICAL con exit-code1, incluso sin parche. No se usan ignore-unfixed, ignores ni excepciones VEX. La integración depende del nuevo run, el laboratorio GitOps, protección de main y revisión del equipo.

Referencia de la base mínima: https://github.com/GoogleContainerTools/distroless/blob/main/base/README.md
