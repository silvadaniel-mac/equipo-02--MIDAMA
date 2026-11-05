# Evidencias S09

## Resultado local

- Semgrep: dos reglas propias probadas, 234 reglas sobre 16 archivos, cero hallazgos en código del proyecto.
- Control negativo SAST: los cuatro patrones inseguros se detectan y el comando bloqueante devuelve 1.
- Gitleaks 8.30.0: 78 commits escaneados del historial alcanzable de la base, cero secretos. Repetir en el SHA del PR para incluir la entrega S09.
- SBOM local: generado con Trivy 0.76.2, CycloneDX 1.7, 476 componentes. La comprobación local verifica estructura y presencia de componentes, no reemplaza un validador completo del esquema estándar.
- Trivy: permanece un HIGH con parche disponible, `CVE-2026-73231`, Faker transitivo de Prism. El gate devuelve 1 correctamente. [Plan de remediación](../../security/remediation-s09.md).
- Calidad S08 y cuatro ejemplos Prism: ver logs adjuntos. La versión final conserva Prism 5.16.0, actualiza YAML y fija lodash corregido.

Los reportes JSON locales se suministran junto al paquete de revisión. El `sbom.json` local **no** constituye el artefacto del último run de Actions exigido por la pauta.

## Evidencia remota pendiente

La conexión API rechazó inicialmente crear la rama (403). Se recuperó el acceso mediante sesión web y se publicó feature/s09-devsecops. Los resultados del PR deben verificarse en GitHub Actions. `main` figuraba `protected=false` y sin rulesets en la revisión inicial; verificar su configuración antes del cierre.

## Capturas que exige la pauta

1. En el PR S09, pestaña **Conversation**, bajar al bloque de checks y expandirlo. Deben verse `security / sast`, `security / sca`, `security / secrets`, sus marcas verdes, el número del PR y la rama. Guardar `01-pr-checks.png` una vez resuelto el HIGH.
2. Recomendado: **Actions → run del PR → Summary → Artifacts**. Mostrar `s09-sca-sbom-<SHA>`, descargarlo y comprobar que contiene `sbom.json`. Guardar `02-sbom-artifact.png`.
3. Prerrequisito: **Settings → Branches / Rules → protección de main**, con revisión y checks requeridos activos. Guardar `03-branch-protection.png`.

La captura obligatoria es la primera. No hay todavía una pantalla válida que muestre esos checks S09 en verde. No usar una captura S08 como sustituto.
