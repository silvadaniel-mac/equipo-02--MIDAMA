# Evidencias S18

El workflow AulaViva S18 academic lab genera artefactos por SHA: integración TAP, demo, evaluación JSON, operación JSON. Descargar el artefacto del run correspondiente, no utilizar métricas de otro commit. Reproducir con Node 24 y los cuatro comandos de DEFENSA-S18.md. No hay evidencia de un staging remoto permanente, Ragas o facturación AWS.

## Primera ejecución comprobada
[Run 45739059840](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45739059840), SHA 3c8541c0325e5d6e20d6f922268aad874b7ed2ac: academic-lab success. Logs: 6/6 integración, cobertura de líneas 96,75% (conjunto instrumentado), 40/40 golden set extractivo, p95 4,67 ms, 100/100 probes, p95 2,09 ms, RTO 6,97 ms y antigüedad del snapshot 7 ms (laboratorio temporal), demo 6 pasos. Contexto 16036 → 3812 bytes y duplicados 6868 → 3812 bytes. No son Ragas, factura ni recuperación cloud. Las métricas corresponden a ese commit, no a futuras ejecuciones.

S10 ampliado: artifacts/academic incluye flujo HTTP contra el pod admitido por Kyverno y reporte ZAP pasivo no autenticado; consultar ejecución antes de afirmar éxito.

### Remediación SAST
[Run S08 45739071574](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45739071574): la regla no-shell-exec detectó cuatro llamadas DatabaseSync.exec de SQLite (DDL y transacciones SQL fijas), no ejecución de shell. Se reemplazaron por sentencias preparadas individuales, conservando transacción y parámetros. No se deshabilitó la regla ni se agregaron excepciones. Verificar nueva ejecución.

SAST [run 45739331906](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45739331906) también bloqueó la llamada HTTP directa del experimento FinOps. Se centralizó el transporte local Ollama en una función de loopback fijo, sin redirecciones, sin hostname dinámico, con timeout y sin datos reales. No se desactivó el gate. La conexión HTTP queda limitada a la máquina del runner; producción debe usar TLS y autenticación.
