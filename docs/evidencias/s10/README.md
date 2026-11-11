# Evidencias de la sesión 10

Los archivos de implementación están en la rama `feature/s10-supply-chain`. La ejecución y sus resultados se incorporarán aquí después de comprobar el run real. No se consideran pruebas las configuraciones sin ejecutar.

## Qué conservar

| Evidencia | Origen |
| --- | --- |
| IaC y rechazo de SSH público | Artefacto `s10-iac-<SHA>` |
| Build, digest y Trivy sobre imagen final | `s10-container-<SHA>` |
| Firma, verify, attestation y pruebas negativas | `s10-signature-slsa-<SHA>` |
| Staging, admisión Kyverno, Falco, incidentes y ZAP | `s10-dast-runtime-<SHA>` |
| Capturas legibles | GitHub Actions y reportes de esa ejecución |

Los reportes descargados deben corresponder al SHA registrado en el cierre de entrega. No guardar tokens, kubeconfigs ni Secrets en esta carpeta.
