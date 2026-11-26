# Evidencias S18

El workflow AulaViva S18 academic lab genera artefactos por SHA: integración TAP, demo, evaluación JSON, operación JSON. Descargar el artefacto del run correspondiente, no utilizar métricas de otro commit. Reproducir con Node 24 y los cuatro comandos de DEFENSA-S18.md. No hay evidencia de un staging remoto permanente, Ragas o facturación AWS.

## Primera ejecución comprobada
[Run 45739059840](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45739059840), SHA 3c8541c0325e5d6e20d6f922268aad874b7ed2ac: academic-lab success. Logs: 6/6 integración, cobertura de líneas 96,75% (conjunto instrumentado), 40/40 golden set extractivo, p95 4,67 ms, 100/100 probes, p95 2,09 ms, RTO 6,97 ms y antigüedad del snapshot 7 ms (laboratorio temporal), demo 6 pasos. Contexto 16036 → 3812 bytes y duplicados 6868 → 3812 bytes. No son Ragas, factura ni recuperación cloud. Las métricas corresponden a ese commit, no a futuras ejecuciones.

S10 ampliado: artifacts/academic incluye flujo HTTP contra el pod admitido por Kyverno y reporte ZAP pasivo no autenticado; consultar ejecución antes de afirmar éxito.
