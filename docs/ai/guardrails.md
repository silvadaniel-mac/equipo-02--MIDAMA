# Guardrails y criterios de aceptación

| Riesgo | Control | Evidencia |
| --- | --- | --- |
| Fuga entre colegios | Verificar JWT, curso y colegio; SQL parametrizado por scope | integración y 6 intentos golden set |
| Inyección en consulta o material | Filtro léxico, fuentes tratadas como datos | integración y casos guardrail |
| Alucinación / cita falsa | Extractivo; adaptador valida índice autorizado; el servidor construye cita literal e ID | dobles de prueba y evaluación |
| PII | Filtro de correo y RUT en preguntas/material recuperado; datos exclusivamente ficticios | integración |
| Sin material | Abstención | 8 casos |
| Falla del LLM | Timeout y fallback extractivo | doble de prueba |

No es defensa exhaustiva. No desplegar a Internet ni cargar información de alumnos. Las pruebas no acreditan equidad o seguridad universal. Ejecutar node services/s18/evaluate.mjs y revisar artifacts S18. Los resultados se generan, no se inventan.
