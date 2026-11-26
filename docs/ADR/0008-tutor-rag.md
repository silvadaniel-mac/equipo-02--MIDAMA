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

### Iteración S18
El experimento de copia generativa exacta falló 20/20 preguntas con fuente: se cambió a selección LLM de pasaje y salida extractiva determinista. No se debilita la autorización ni el gate de exactitud. La generación de explicaciones libres sigue pendiente de evaluación y revisión docente.

### Decisión de enrutamiento híbrido
El experimento de extracción de números mediante LLM mantuvo el fallo del caso 1810 (39/40 del sistema). La coincidencia exacta es una tarea de recuperación, no de generación ni de inferencia: el componente de búsqueda literal devuelve exclusivamente el pasaje seguro autorizado que contiene el token completo y se abstiene ante ambigüedad. La selección temática sigue usando el modelo real opcional. Evaluar rutas separadamente y nunca atribuir búsqueda literal al LLM. No se reducen los 40 casos de aceptación end-to-end.
