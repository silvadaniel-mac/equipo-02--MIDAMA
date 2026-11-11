# Evidencias S10 · AulaViva MIDAMA

El [PR #8](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/pull/8) incorpora la implementación y los resultados reales. Este índice conserva una ejecución inmutable completa, aunque commits posteriores de documentación o mantenimiento produzcan otros runs.

## Ejecución de referencia aprobada

- Run: [43115051073, todos los jobs S10 correctos](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/43115051073).
- Commit: `119ab658d8c434cc8b06e73306e9a71684bed7fe`.
- Imagen: `ghcr.io/silvadaniel-mac/aulaviva-api-s10@sha256:d27225b2897a0e09cfa0286d3cf4c0f6653e33fd459f945c2d7ae1c456babd3a`.
- Identidad OIDC: `https://github.com/silvadaniel-mac/equipo-02--MIDAMA/.github/workflows/supply-chain-s10.yml@refs/heads/feature/s10-supply-chain`.
- Issuer: `https://token.actions.githubusercontent.com`.
- La policy versionada confía en `main`; únicamente el clúster efímero de la rama recibe su identidad exacta durante la prueba.

## Resultados comprobados

| Control | Resultado | Evidencia conservada |
| --- | --- | --- |
| S09: SAST, SCA, secrets y calidad | Todos aprobados | Jobs del run y artefactos S09 |
| Checkov Terraform | 1 aprobado, 0 fallos, 0 omitidos; sin errores de parseo | ZIP `iac/checkov.json` |
| IaC negativo | SSH `0.0.0.0/0` rechazado por CKV_AWS_24 | ZIP `iac/checkov-negative.json` |
| Trivy sobre imagen final | 0 HIGH y 0 CRITICAL, sin ignorar CVEs sin parche | ZIP `container/trivy-image.json` |
| Cosign | Firma, claims, certificado e inclusión en Rekor verificados | [Salida real](cosign-verify-119ab65.txt) |
| Firma negativa | Sin firma: exit 10; identidad ajena: exit 12 | [Resumen real](controles-firma-119ab65.txt) |
| SLSA | Attestation v0.2 firmada; digest, SHA y builder verificados | [Verificación](slsa-verify-119ab65.txt) y payload en ZIP |
| Kyverno | Imagen firmada admitida; digest sin firma rechazado por webhook | [Rechazo real](admission-negative-119ab65.txt) |
| Falco | 3 reglas propias observadas, ninguna faltante; 6 registros High de simulacro | [Resumen](falco-summary-119ab65.json), eventos e incidentes en ZIP |
| ZAP baseline | 10 URLs, 67 PASS, 0 FAIL y 0 WARN; gate Medium+ aprobado | [Gate](zap-gate-119ab65.txt), HTML y JSON en ZIP |
| Gate ZAP negativo | Un hallazgo Medium sintético produce rechazo | ZIP `dast-runtime/zap/negative-gate.txt` |

El JSON ZAP conserva **1 tipo de alerta informativa**, `Non-Storable Content`, con dos instancias: `/readyz` y `/api/v1/contents`. Corresponde al header intencional `Cache-Control: no-store`; no se eliminó del reporte. No hay alertas Low, Medium ni High. El contador INFO del resumen baseline y el inventario completo del JSON no son el mismo dato.

Los seis incidentes Falco incluyen las tres reglas propias y tres eventos de la regla integrada `Drop and execute new binary in container`. Todos pertenecen a la sonda sintética y están marcados como `drill`.

## Archivos y capturas

- [Resultados legibles por máquina](resultados-119ab65.json).
- [Reportes originales completos](reportes-run-43115051073.zip), con `SHA256SUMS.txt` para comprobar integridad de los archivos descargados.
- [Capturas de GitHub Actions](capturas/): Checkov, Trivy, Cosign, controles negativos, SLSA, admisión, Falco, ZAP y resumen del pipeline. Son capturas reales; la PPT solo recorta sus márgenes mediante el encuadre nativo de imagen.
- Los artefactos del run permanecen disponibles durante su período de retención de Actions. El ZIP versionado conserva los reportes de referencia más allá de esa retención.

## Correcciones realizadas durante la implementación

1. Falco 0.45.2 rechazó una comparación CIDR con `fd.sip`. Se corrigió a `fd.snet`, se eliminó `evt.dir` deprecado y se verificó la carga sin errores ni warnings. Se conserva [el diagnóstico inicial](falco-diagnostico-inicial.txt). El rechazo inicial no se cuenta como ejecución aprobada.
2. El recolector conserva todas las alertas High del namespace del equipo, además de comprobar la presencia de las tres reglas propias. Ninguna alerta High queda solo en el log.
3. El laboratorio S08 usaba `ubuntu-latest`, que pasó a Ubuntu 26.04 incompatible con Playwright 1.56.1. Se fijó Ubuntu 24.04 y se comprobó el laboratorio Argo CD.
4. S07 perdió inicialmente el log del Job de carga. Tras conservarlo, el run `43118001799` mostró 8 `ECONNRESET` y los eventos del clúster confirmaron timeouts de readiness/liveness y un reinicio: el trabajo CPU síncrono bloqueaba el event loop. Se dividió el mismo trabajo en 20 tramos de 2 ms que ceden al event loop entre tramos, conservando 12 clientes, 120 s, timeout de 5 s y tolerancia de cero errores. El test nuevo exige que healthz responda mientras sigue en curso la carga: falla con el código anterior y pasa con la corrección. También se exige una muestra de Metrics Server para cada Pod nuevo. Véase [corrección y validación](s07-correccion.md).

## Alcance y revisión del dueño

Se prueba un staging HTTP temporal por port-forward, sin datos personales. Los endpoints de negocio pendientes devuelven 501; este baseline no acredita seguridad de autenticación, autorización ni flujos que todavía no existen. Build L2 se interpreta conforme a la consigna: servicio hospedado y provenance firmada y verificada; no se declara certificación externa ni L3. Falco registra incidentes; un despliegue permanente requiere un receptor supervisado de alertas.

La protección de `main`, la aprobación obligatoria y los checks requeridos deben activarlos el dueño o un administrador. Checks S10 disponibles: `security / sast`, `security / sca`, `security / secrets`, `quality`, `iac-scan`, `container-scan`, `sign-and-attest`, `dast` y `delivery`. La entrega debe subirse antes del inicio de S11.
