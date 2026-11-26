# Model card — AulaViva S18

Responsable: AI/Data Lead; revisión QA y docente pendiente. Versión: recuperador extractivo S18, adaptador opcional Ollama. Propósito: apoyo escolar en español mediante citas de descripciones autorizadas. No califica estudiantes ni decide por ellos. Solo datos ficticios.

- Recuperación léxica de máximo dos fuentes, filtradas por colegio/curso antes de recuperar. Respuesta literal y referencia de contenido o abstención. No se descargan PDFs ni se consulta Internet.
- Golden set: 40 casos sintéticos (20 con fuente, 8 fuera de contexto, 6 guardrails, 6 cruces). La evaluación compara fuente, texto exacto y estado HTTP. No constituye Ragas, fairness ni evaluación pedagógica independiente.
- Adaptador LLM: timeout, respuesta JSON, cita exacta verificada contra fuente autorizada; rechazo o fallback. Los dobles de prueba no prueban un modelo real; al activar S18_OLLAMA_MODEL la evaluación exige modo llm-verified-quote en casos con fuente.
- Limitaciones: corpus pequeño, preguntas cortas, coincidencias léxicas, expresiones de PII e inyección no exhaustivas. Antes de datos reales: pruebas por nivel y asignatura, revisión docente y jurídica, Ragas con evaluador independiente, mediciones de latencia y costo.
- Privacidad: Ley 21.719 (vigencia 1 de diciembre de 2026) y art. 16 quáter de Ley 19.628 modificada: especial resguardo de menores, finalidad, minimización, base de licitud y retención; no constituye certificación legal. No registrar secretos ni datos reales en prompts; destruir las bases temporales. Detener el piloto ante fuga, corregir y repetir pruebas.

Referencias: [BCN](https://www.bcn.cl/leychile/navegar?idNorma=1209272&idVersion=2026-12-01), [Ragas](https://docs.ragas.io/en/latest/concepts/metrics/available_metrics/), [Charter](../../CHARTER.md).
