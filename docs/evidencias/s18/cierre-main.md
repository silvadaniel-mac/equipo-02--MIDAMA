# Cierre validado de S18 — 26 de noviembre de 2026

Versión de aplicación validada: [309e3e7](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/commit/309e3e7b71571d77a0fad4d011222b90beed1b5e). [PR #12](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/pull/12) fusionado por el propietario. Las cinco ejecuciones sobre main terminaron con success.

| Workflow | Evidencia |
| --- | --- |
| S05 Contrato API | [45745217366](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217366) |
| S07 Plataforma | [45745217434](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217434) |
| S08 CI/GitOps | [45745217466](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217466) |
| S10 Supply Chain | [45745217435](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217435) |
| S18 Laboratorio e IA | [45745217402](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217402) |

## Resultados observados en el SHA de aplicación

- Integración: 9 pruebas aprobadas. Cobertura de líneas instrumentadas 96,57%; ramas 79,05%; funciones 87,80%.
- Sistema híbrido con Qwen2.5 7B: 40/40 (19/19 consultas temáticas resueltas por el LLM, 1/1 búsqueda literal determinista, 8/8 fuera de contexto, 6/6 guardrails y 6/6 aislamiento). No equivale a 40 respuestas del LLM puro. El sistema extractivo base también aprueba 40/40.
- Ragas sin juez LLM, 20 casos con fuente: precisión de recuperación 0,9999999999; recall 1,0. No mide calidad de explicación generativa ni evaluación docente.
- Disponibilidad: 100/100 probes en muestra breve. Recuperación SQLite: RTO 16,78 ms, antigüedad de snapshot 47 ms, ejercicio temporal, no recuperación cloud.
- FinOps: 1005 → 361 tokens de entrada en recuperación (64,1%); 522 → 361 en deduplicación controlada (30,8%). Cinco preguntas, no ahorro facturado.
- S10: jobs quality, IaC, SAST, SCA, secretos, container-scan, sign-and-attest, DAST y delivery aprobados. DAST pasivo del laboratorio: 0 alertas Medium/High según gate; no equivale a prueba exhaustiva autenticada.
- [Artefacto académico](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217402/artifacts/15082971746) y [artefacto LLM](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45745217402/artifacts/15082289999), sujetos a retención de Actions. Los comandos de reproducción están en [DEFENSA-S18](../../DEFENSA-S18.md).

## Gobernanza y límites

La rama main quedó protegida, comprobado mediante API de ramas el 26/11/2026. La configuración detallada se observó en capturas del propietario: dos aprobaciones, CODEOWNERS, ocho checks, actualización de rama, resolución de conversaciones y sin bypass, force push ni eliminación. El conector no tiene permiso administrativo para consultar todas las reglas. Las aprobaciones se aplican a futuros PR, no retroactivamente al PR #12.

El repositorio externo [equipo-02-gitops](https://github.com/silvadaniel-mac/equipo-02-gitops) está configurado y protegido. La [promoción automática dev](../s08/promocion-externa.md) fue comprobada. El [backend S3 remoto](../s07/backend-s3.md) fue inicializado con la raíz del proyecto y probado mediante escritura y bloqueo concurrente en una raíz aislada de AWS Academy. El laboratorio no es un entorno productivo permanente. No se ha realizado auditoría pedagógica ni legal independiente.

## Revalidación final
Los cinco workflows sobre f61eb33 aprobaron: [S05](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184380), [S07](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184474), [S08](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184545), [S10](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184487), [S18](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45751184390).
