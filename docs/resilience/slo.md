# SLI y SLO

SLI: GET /readyz HTTP 200 en no más de 2 s. Objetivo propuesto: 99,5% en 30 días (presupuesto de error 216 minutos). La muestra automatizada S18 toma 100 probes separadas 20 ms y guarda estado, latencia y ventana. No es un histórico de 30 días. Para operación real, ejecutar probes cada minuto desde fuera del servicio y alertar al consumir presupuesto. No se afirma observabilidad continua. Ver operations.mjs y el reporte de Actions.
