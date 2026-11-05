# S09 · DevSecOps I — Implementación y evidencias

## Objetivo

Extender el pipeline CI/CD de la sesión 08 mediante controles de seguridad automatizados, incorporando análisis estático de código, análisis de dependencias, búsqueda de secretos y modelado de amenazas.

Proyecto: AulaViva — Equipo MIDAMA.
Rama principal: `main`.
Pull Request: [#7 — DevSecOps S09](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/pull/7).
Commit de integración: `63dade0`.

## Verificación de requisitos

| Requisito | Implementación y evidencia | Estado |
| --- | --- | --- |
| SAST, SCA y Secrets en paralelo | Workflows `security.yml` y `ci.yml`; tres checks verdes en el PR #7 | Completado |
| OWASP y dos reglas propias | Semgrep con reglas públicas y `.semgrep/aulaviva.yml`, con pruebas de patrones seguros e inseguros | Implementado |
| Trivy HIGH/CRITICAL | Escaneo de dependencias con bloqueo de hallazgos según la política configurada | Completado |
| SBOM CycloneDX | Artefacto remoto `s09-sca-sbom` generado y descargado | Completado |
| Gitleaks con historial | Análisis de secretos mediante GitHub Actions y reporte del último run | Completado |
| STRIDE | Modelo y mitigaciones descritos en `docs/threat-model.md` | Documentado |
| Remediación y VEX | Correcciones documentadas en `docs/security/remediation-s09.md`; plantilla OpenVEX disponible | Documentado |
| Evidencia de PR | Checks SAST, SCA, Secrets, Quality, Build y GitOps aprobados en PR #7 | Completado |
| Protección de main | Requiere permisos administrativos del propietario, actualmente sin acceso a su cuenta | Pendiente por permisos |
| Cuenta Semgrep gratuita | CLI funcional sin vinculación a una cuenta del equipo | Pendiente de confirmar si se exige |
| Retención externa de cinco años | No existe almacenamiento externo configurado para esa retención | Pendiente |

## Resultados de GitHub Actions

El PR #7 fue integrado a `main` con los controles automáticos aprobados. Entre ellos se verificaron:

- `security / sast`
- `security / sca`
- `security / secrets`
- `quality (Node 22)` y `quality (Node 24)`
- `sast`
- `build-and-push`
- `gitops-lab`

El trabajo `promote` se omitió por diseño durante el Pull Request. Esto no constituye un error.

Luego de la integración, se ejecutó manualmente `AulaViva S09 Security #1` sobre `main` y se obtuvieron resultados exitosos en los tres análisis de seguridad.

## Evidencias y artefactos

- PR integrado y checks: https://github.com/silvadaniel-mac/equipo-02--MIDAMA/pull/7
- Evidencia del run del PR: https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/42123456710
- Evidencias locales y documentación: `docs/evidencias/s09/`
- Modelo de amenazas: `docs/threat-model.md`
- Correcciones de seguridad: `docs/security/remediation-s09.md`

Los reportes descargados del último workflow manual en `main` incluyen SAST, SCA/SBOM y Secrets. Los reportes revisados no registran hallazgos en el alcance analizado. Esto no garantiza ausencia de vulnerabilidades fuera de ese alcance.

## Remediaciones realizadas

Durante el desarrollo se detectaron dependencias vulnerables y un problema de seguridad asociado a bibliotecas de la imagen Docker.

Se reemplazó la dependencia vulnerable del servidor de simulación de API y se corrigió la composición del contenedor usando una base Distroless no root. Las decisiones, pruebas y cambios se encuentran descritos en `docs/security/remediation-s09.md`.

No se desactivaron los controles de seguridad para forzar la aprobación del pipeline.

## Modelo de amenazas STRIDE

El análisis STRIDE identifica riesgos de suplantación de identidad, manipulación de datos, repudio, divulgación de información, denegación de servicio y elevación de privilegios.

Se distinguen controles ya implementados de mitigaciones futuras, dado que los endpoints académicos, la autenticación de negocio y la persistencia todavía no están completamente implementados.

## Limitaciones pendientes

### Protección de la rama principal

La protección de `main` no pudo activarse porque requiere permisos administrativos. El propietario del repositorio no tiene actualmente acceso a su cuenta. Esta limitación se declara expresamente y no se presenta como tarea completada.

### Cuenta Semgrep

El análisis mediante Semgrep CLI funciona con las reglas configuradas, pero no se ha confirmado una cuenta gratuita vinculada al equipo.

### Retención de evidencias

La configuración actual del workflow contempla retención de 30 días para SAST y Secrets y 90 días para SCA/SBOM, sujeta a los límites del repositorio. La retención externa a cinco años queda pendiente.

## Conclusión

La sesión 09 permitió incorporar prácticas DevSecOps al proyecto AulaViva. Se integraron análisis de código, dependencias y secretos, se generó un SBOM, se documentó el modelo STRIDE y se corrigieron vulnerabilidades detectadas durante el desarrollo.

El PR #7 fue integrado y las ejecuciones verificadas finalizaron correctamente. La protección de la rama principal y los prerrequisitos administrativos quedan expresamente pendientes, sin afectar las evidencias técnicas ya obtenidas.
