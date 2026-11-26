# AulaViva — entrega final S18

Equipo MIDAMA. Base histórica S01–S10: 7518b33d. No hubo clases S11–S17 y la presentación oral se canceló según información del equipo. Esta entrega escrita reúne evidencia y límites; no implica que el profesor haya modificado la rúbrica.

## Reproducción
Node 24; desde raíz:
```sh
node --test services/s18/integration.test.mjs
node services/s18/demo.mjs
node services/s18/evaluate.mjs
node services/s18/operations.mjs
```
Servidor HTTP real en loopback con SQLite temporal y JWT ficticio. No requiere AWS ni claves externas. Publica contenido, consulta, recupera fuente, bloquea colegio ajeno y se abstiene. Las notas, informes y evaluaciones quedan como diseño. El servidor histórico S07–S10 no se reemplaza.

## Trazabilidad
| Criterio S18 | Evidencia | Alcance |
| --- | --- | --- |
| Demo 15 | services/s18/demo.mjs | Flujo académico local; staging efímero kind incorporado, validar run; cloud permanente pendiente |
| Arquitectura 15 | [C4 L3](c4/l3-component-s18.puml), [8 ADRs](ADR/registro-s18.md) | Decisión nueva propuesta, revisión pendiente |
| DevSecOps 12 | [S10](sesiones/s10-supply-chain.md), Actions | Pipeline histórico ampliado para S18; validar run; main y GitOps externo pendientes |
| IA 12 | [model card](ai/model-card.md), [golden set](ai/golden-set.json), [guardrails](ai/guardrails.md) | Recuperación Ragas aprobada en runs previos; tutor híbrido (LLM temático y búsqueda literal determinista), nueva evaluación pendiente |
| Resiliencia 10 | [SLO](resilience/slo.md), [game day](resilience/game-day.md) | Ejercicio SQLite, muestra corta |
| FinOps 8 | [presupuesto](finops/cost-estimation.md) | Medición real de tokens de entrada y estimación, no factura |
| Calidad 8 | integration.test.mjs, CI | Pruebas reproducibles |
| Panel, equipo y tiempo 20 | Charter y reparto de la PPT | No afirmar puntaje oral ni asistencia |

## Entregables por rol
Antonella: producto y roadmap; Daniel: C4 y ADRs; Ian: demo y calidad; Allen: seguridad; Miguel: IA/datos; Matías: resiliencia y costos.

## Roadmap
1. Autenticación institucional, base PostgreSQL y staging firmado; mantener aislamiento.
2. Tutor generativo con citas, evaluación Ragas y revisión docente, privacidad de menores.
3. GitOps externo, protección main, SLO continuo, restauración RDS y medición de costos reales.

## Evidencias
[Índice](evidencias/s18/README.md). Usar el SHA exacto del run. Las pruebas históricas no cubrían el nuevo servicio; consultar las ejecuciones de S18 y S10 ampliado. El staging es efímero y usa SQLite de una réplica. No fabricar clases ni aprobaciones. No exponer el laboratorio a red pública.
