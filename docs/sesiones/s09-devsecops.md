# S09 · DevSecOps I

## Objetivo

Extender el pipeline verde de S08 con seguridad temprana. Base revisada: `7f3627a`, con CI S08 verde en [run 40998232686](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/40998232686).

| Requisito de diapositiva 7 | Implementación | Evidencia necesaria |
| --- | --- | --- |
| SAST, SCA y secrets en paralelo | security.yml reusable, llamado desde ci.yml | Tres checks verdes en el PR |
| OWASP + dos reglas propias | p/owasp-top-ten, .semgrep/aulaviva.yml y reglas S08 | Reporte Semgrep y pruebas con casos seguros/inseguros |
| Trivy filesystem HIGH/CRITICAL con parche | include-dev-deps, ignore-unfixed, exit-code 1 | trivy.json del run |
| SBOM CycloneDX | Trivy genera artifacts/sbom.json y valida estructura/componentes | Artefacto s09-sca-sbom-SHA descargable |
| Gitleaks con historial | checkout fetch-depth 0 y git --log-opts=--all | Reporte redacted del run |
| STRIDE aplicado | docs/threat-model.md, activos, flujos, límites y ocho amenazas | Documento y tabla de mitigación |
| Re-triage y VEX | README y plantilla OpenVEX sin aprobación automática | PR con remediación o justificación de hallazgos |
| Protección de rama | Falta activar, lectura API indica protected=false | Captura de configuración por administrador |
| Cuenta Semgrep free | No creada/vinculada. CLI usa reglas públicas sin token | Registrar cuenta del equipo si el docente exige este prerrequisito literal |

## Ejecución local

```bash
npm ci
npm run ci:quality
semgrep --test --config .semgrep/aulaviva.yml tests/security/aulaviva.js
semgrep scan --config p/owasp-top-ten --config .semgrep/ --config .semgrep.yml --error --strict --metrics=off services packages scripts
trivy fs --scanners vuln --include-dev-deps --severity HIGH,CRITICAL --ignore-unfixed --exit-code 1 .
trivy fs --format cyclonedx --include-dev-deps --output sbom.json .
python3 scripts/validate-sbom.py sbom.json
gitleaks git --log-opts="--all" --redact .
```

Las pruebas sintéticas viven fuera de los objetivos de SAST productivo y solo se usan en `semgrep --test`. Sus cuatro patrones vulnerables deben detectarse y sus dos ejemplos seguros no deben detectarse. Los resultados locales no reemplazan un run de GitHub Actions.

## Retención

SAST y secretos: 30 días. SBOM y SCA: 90 días, sujeto al máximo de GitHub del repositorio. La recomendación de cinco años de la diapositiva 6 necesita almacenamiento externo con política de retención y acceso controlado, todavía no configurado. El mini-lab exige el artefacto del último run.

## Cierre

Abrir PR feature/s09-devsecops hacia main, adjuntar el plan de remediación y esperar todos los checks. Capturar el PR con sus tres checks. No integrar ni declarar completada la entrega mientras falten ese run, el SBOM remoto o protección de rama.
