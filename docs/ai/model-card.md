# Model card — AulaViva S18

Responsable: AI/Data Lead; revisión QA y docente pendiente. Versión: recuperador extractivo S18, adaptador opcional Ollama. Propósito: apoyo escolar en español mediante citas de descripciones autorizadas. No califica estudiantes ni decide por ellos. Solo datos ficticios.

- Recuperación léxica de máximo dos fuentes, filtradas por colegio/curso antes de recuperar. Respuesta literal y referencia de contenido o abstención. No se descargan PDFs ni se consulta Internet.
- Golden set: 40 casos sintéticos (20 con fuente, 8 fuera de contexto, 6 guardrails, 6 cruces). La evaluación compara fuente, texto exacto y estado HTTP. No constituye Ragas, fairness ni evaluación pedagógica independiente.
- Adaptador LLM: timeout, selección JSON del índice de una fuente autorizada; la aplicación emite cita literal; rechazo o fallback. Los dobles de prueba no prueban un modelo real; al activar S18_OLLAMA_MODEL la evaluación exige modo llm-selected-extractive en casos con fuente.
- Limitaciones: corpus pequeño, preguntas cortas, coincidencias léxicas, expresiones de PII e inyección no exhaustivas. Antes de datos reales: pruebas por nivel y asignatura, revisión docente y jurídica, Ragas con evaluador independiente, mediciones de latencia y costo.
- Privacidad: Ley 21.719 (vigencia 1 de diciembre de 2026) y art. 16 quáter de Ley 19.628 modificada: especial resguardo de menores, finalidad, minimización, base de licitud y retención; no constituye certificación legal. No registrar secretos ni datos reales en prompts; destruir las bases temporales. Detener el piloto ante fuga, corregir y repetir pruebas.

Referencias: [BCN](https://www.bcn.cl/leychile/navegar?idNorma=1209272&idVersion=2026-12-01), [Ragas](https://docs.ragas.io/en/latest/concepts/metrics/available_metrics/), [Charter](../../CHARTER.md).

## Extensión evaluable
CI S18 ejecuta Ragas 0.4.4 NonLLMContextPrecisionWithReference y NonLLMContextRecall sobre los 20 casos con fuente, con gate 0,85. No es el juez LLM de faithfulness; la cita se verifica literalmente. Un job separado descarga Qwen2.5 1.5B mediante Ollama, restringe salida JSON por esquema y exige selección correcta con cita exacta devuelta por la aplicación, no fallback. El modelo selecciona; no genera explicación libre. Los resultados y digest se guardan en artifacts; consultar el run antes de afirmar aprobación. Referencias: https://docs.ragas.io/en/latest/concepts/metrics/available_metrics/context_recall/ y https://ollama.com/library/qwen2.5:1.5b.

### Iteración observada
Run [45739533067](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45739533067), SHA cb47200: Qwen2.5 1.5B con copia literal generativa obtuvo 20/40 (0/20 con fuente; 20/20 restantes). Los 20 resultados con fuente fueron rechazados por el verificador: no se presentó una cita falsa. Se cambió el diseño: el modelo selecciona un índice permitido y la aplicación devuelve texto e ID directamente del corpus autorizado. Se mantiene el gate de fuente esperada y modo real del modelo. Verificar el nuevo run antes de afirmar aprobación. No se trata de generación libre ni evaluación pedagógica.

### Tercera iteración del experimento
El modelo 1.5B con selección de índice alcanzó 25/40 (5/20 con fuente; 15 abstenciones seguras) en [run 45739894435](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45739894435). Se ensaya Qwen2.5 7B y se aclara en español que una consulta temática corta no requiere una pregunta completa. Se incluyen títulos, sin cambiar corpus, preguntas, criterios, guardrails ni modo de evaluación. El servicio por defecto permanece extractivo; no se afirma éxito antes de ejecutar.
