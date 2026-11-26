# Cierre AulaViva S18

Base: main 7518b33d. Este trabajo amplía las diez sesiones efectivamente cursadas, sin inventar entregas S11–S17. Rama de revisión; no representa todavía una entrega aprobada en main.

## Prueba local
Node.js 24, desde la raíz: node services/s18/demo.mjs. El laboratorio usa un servidor HTTP en loopback, SQLite temporal y tokens de identidades ficticias. No requiere AWS ni credenciales externas. No exponer a Internet. La demo cubre contenidos y tutor; notas, informes y evaluaciones siguen como diseño. El servidor histórico S07–S10 se conserva.

## Evidencias
- [C4 nivel 3](c4/l3-component-s18.puml).
- [Registro consolidado de ocho ADRs](ADR/registro-s18.md).
- [Tutor contextual](../services/s18/tutor.mjs).
- [Servidor académico](../services/s18/server.mjs).
- [Demo](../services/s18/demo.mjs).

## Pendientes
Pruebas de integración, golden set, informes, SLO, recuperación y FinOps; ejecución en CI; staging firmado del nuevo servicio, LLM real y Ragas; revisión docente; protección main y GitOps externo; actualización de PPT con SHA final. No afirmar que el pipeline histórico S10 escanea este servicio nuevo hasta que se integre y se pruebe.
