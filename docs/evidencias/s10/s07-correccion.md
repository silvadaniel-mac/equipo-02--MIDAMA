# Corrección del laboratorio S07 detectada al validar S10

## Causa comprobada

Run fallido: https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/43118001799

El Job realizó 6454 solicitudes con respuesta y detectó 8 errores `ECONNRESET`. Los eventos registraron fallos de probes por timeout y el reinicio de un contenedor. El endpoint sintético acumulaba trabajo CPU síncrono en el hilo HTTP y podía impedir contestar las probes dentro de su timeout. El HPA sí aumentó de 2 a 4 y luego a 5 Pods; el error no era la ausencia de escalamiento.

## Corrección

- La carga CPU se reparte en 20 tramos de 2 ms con `setImmediate` entre tramos. Las probes pueden atenderse entre esos tramos.
- Se conservan 12 clientes, duración de 120 s, timeout por solicitud de 5 s y rechazo de cualquier error.
- Antes de cargar se exige readiness por el Service y muestras de CPU de todos los Pods nuevos, evitando aceptar datos residuales del rollout anterior.
- Se conserva el log del Job antes de eliminarlo, diferenciando fallo y finalización sin esperar siempre al timeout.
- El runner del laboratorio se fija a Ubuntu 24.04.

## Regresión y calidad local

`npm run ci:quality` aprobado: lint, formato, 7 pruebas del servidor y 10 del contrato/mock. Cobertura del servidor: 80,49 % de líneas y 96 % de ramas. `bash -n scripts/verify-hpa.sh` correcto.

El test `las probes responden mientras la carga CPU sigue en curso` pasa con la corrección. Al ejecutarlo contra una copia temporal del código anterior, falla con `La carga no debe bloquear las probes`; prueba que detecta el problema y no solo repite la implementación.

La validación real de subida y bajada de HPA se comprueba en los checks del PR #8 antes de integrar. Los reportes de Actions identifican su SHA exacto.
