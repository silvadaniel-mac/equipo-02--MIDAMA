# Evidencias S08

Ejecución local: 29/10/2026, Node 24.22.1, Semgrep 1.183.0, kubectl 1.32.2 y actionlint 1.7.7.

Los PNG son reportes visuales de archivos y resultados reales, no capturas de GitHub Actions ni de una instancia Argo CD. Los textos originales y renders YAML se incluyen para revisar los resultados completos.

- quality-local.txt: lint, formato, pruebas, generación y contrato correctos.
- coverage-local.txt: 5 pruebas HTTP, 75,76% de líneas del servidor.
- semgrep-local.json: 4 archivos examinados, 4 reglas, sin hallazgos.
- semgrep-control-negativo.txt: un archivo temporal con eval genera un hallazgo bloqueante, código de salida 1.
- coverage-control-negativo.txt: exigir 100% de líneas provoca un fallo, código de salida 1.
- sca-runtime.txt: npm audit sin vulnerabilidades de dependencias runtime.
- render-dev.yaml y render-prod.yaml: salida real de kubectl kustomize.
- Workflows ci.yml y GitOps validate.yml: actionlint terminó con código 0, sin diagnósticos.

No se ejecutaron aquí Docker, GHCR, Cosign ni el clúster kind. No hay captura Synced/Healthy ni PR creados: la integración de GitHub rechazó la creación de una rama con 403 Resource not accessible by integration. No se modificó el remoto.
