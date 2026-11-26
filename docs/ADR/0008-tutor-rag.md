# ADR 0008 — Recuperación autorizada, citas y abstención del tutor

Estado: propuesto, requiere revisión por pares. Fecha: 25-11-2026.

## Contexto
El tutor debe responder usando material del curso autorizado y evitar cruces entre colegios. El piloto no utiliza datos reales ni califica estudiantes.

## Decisión
Validar identidad, tenant y curso antes de recuperar. Usar un baseline extractivo con recuperación léxica y cita literal identificada; abstenerse si no hay fuentes. Probar guardrails y aislamiento. La generación con LLM es una evolución que requiere evaluación real.

| Alternativa | Motivo |
| --- | --- |
| LLM sin recuperación | Descartada por falta de trazabilidad de fuentes. |
| RAG vectorial con LLM | Objetivo futuro; necesita embeddings, modelo y evaluación. |
| Recuperación extractiva | Elegida para laboratorio por simplicidad y auditabilidad. |

## Consecuencias
El corpus se limita a descripciones sintéticas; no se descargan PDF ni URLs. Las reglas léxicas no son protección exhaustiva. SQLite de instancia única no reemplaza PostgreSQL/RDS. Antes del piloto: revisión docente, autenticación institucional, pruebas adversariales, evaluación Ragas y medición de costo. No presentar el baseline como LLM validado.
