# Triage y plan de remediación S09

Revisión local: 5 de noviembre de 2026. Responsable propuesto: mantenedor de dependencias del equipo MIDAMA. Revisión independiente pendiente.

| Hallazgo | Resultado y decisión | Plan y plazo |
| --- | --- | --- |
| CVE-2026-4800 · lodash 4.17.21 | Corregido mediante override 4.18.1. Prism conserva versión 5.16.0. Trivy ya no reporta este CVE en el lockfile final | Conservar pruebas de contrato y cuatro ejemplos Prism, retirar override cuando la cadena upstream adopte la corrección |
| YAML 2.8.1 | Dependencia directa actualizada a 2.9.1 | Ejecutar lint y contrato después del cambio |
| CVE-2026-73231 · @faker-js/faker 5.5.3 | **HIGH pendiente**. Cadena: Prism, http-spec, postman-collection, Faker. Trivy exige versión 10.5.0 o posterior. El runtime Docker copia solo server.mjs y no incorpora node_modules, pero la herramienta sigue instalada en CI | Antes del 4 de diciembre de 2026, evaluar actualización upstream o sustitución del parser/mock, probar API y ejemplos. Registrar responsable nominal al abrir PR. No aprobar despliegue con el gate rojo |

Una actualización mayor de Faker no es intercambiable con la versión antigua: Postman importa `@faker-js/faker/locale/en` y usa APIs antiguas. No se aplica un override mayor sin migración y pruebas. El downgrade de Prism no se conserva porque introducía otros CVE, incluidos críticos.

No se emite VEX `not_affected` solo porque sea una devDependency. No hay aprobación independiente ni prueba suficiente de no alcanzabilidad en CI. El gate SCA permanece bloqueante con exit code 1. El PR debe describir este hallazgo y el plan como exige la nota de la diapositiva 7. La captura de tres checks verdes requiere resolverlo o una excepción específica, justificada y aprobada con vencimiento.
