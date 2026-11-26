# Game day y post-mortem reproducible

Objetivo: restaurar contenido SQLite desde respaldo consistente y comprobar aislamiento. Solo un directorio temporal creado por el script; nunca datos de producción. Paso 1 publicar material, medir probes, cerrar DB, copiar snapshot. Paso 2 reiniciar y crear un registro posterior. Paso 3 cerrar y eliminar copia de trabajo, restaurar snapshot, reiniciar, verificar contenido preservado, pérdida esperada del registro posterior, HTTP 404 a colegio ajeno y readiness 200.

RTO: duración entre iniciar recuperación y comprobar servicio. RPO: antigüedad del respaldo al corte. Metas de diseño 60 min y 24 h. Causa del incidente simulado: pérdida de la copia de trabajo; mitigación: snapshot consistente. Prevención: backup programado y prueba de restauración; verificar integridad y permisos. Resultados reales: reporte generado por services/s18/operations.mjs; no confundir con RDS ni producción. [Runbook previo](../runbooks/aulaviva-availability.md).
