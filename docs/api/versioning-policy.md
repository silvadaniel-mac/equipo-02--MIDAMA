# Política de versionado y deprecación

El contrato canónico es `api/openapi.yaml`. La API usa `/api/v1`; `info.version` sigue SemVer y el cliente se regenera con cada modificación. El borrador `MiDamaAPI.yaml` se migra a esta ubicación y se retira para evitar contratos divergentes.

## Compatibilidad

PATCH corrige documentación o ejemplos sin cambiar comportamiento. MINOR agrega operaciones o campos opcionales sin afectar consumidores existentes. MAJOR corresponde a una nueva ruta `/api/v2`, por ejemplo al eliminar o renombrar campos, agregar campos obligatorios, reducir rangos permitidos, cambiar status o endurecer permisos. Ampliar enums de salida también puede romper clientes exhaustivos y requiere evaluación de compatibilidad. Los consumidores deben tolerar campos desconocidos.

## Deprecación

Marcar `deprecated: true`, documentar reemplazo y guía de migración en el PR, y notificar con al menos tres meses de anticipación antes del retiro. Mantener comportamiento durante la transición. Las respuestas del recurso deprecado deben incluir `Deprecation` (fecha de inicio), `Sunset` (fecha HTTP de retiro) y `Link` con `rel="deprecation"` hacia la guía. Una corrección urgente de seguridad se evalúa y comunica explícitamente, con medidas de migración.

El informe académico permanece activo: la marca deprecated del borrador anterior no identificaba reemplazo ni fecha, por lo que se elimina hasta que exista un plan real.

## Idempotencia y acceso

Cada POST exige `Idempotency-Key` UUID. El backend debe reservar la clave atómicamente por colegio, usuario y operationId, guardar hash del cuerpo y respuesta durante 24 horas y reproducir status, cuerpo y Location ante un reintento idéntico. Cuerpo diferente retorna 409. Solicitud concurrente pendiente retorna 409 y puede reintentarse. Tras 24 horas la clave puede crear otro recurso. GET no modifica estado.

Validar JWT antes de resolver recursos. Un usuario sin acceso al colegio o sin rol obtiene 403. Un recurso que no pertenece al colegio autorizado obtiene 404 para no filtrar su existencia. Apoderados solo pueden consultar estudiantes vinculados. Los ejemplos no contienen datos personales reales. Todas las respuestas incluyen X-Trace-Id; errores también incluyen trace_id.

## Diseño y revisión

REST es adecuado para el frontend y recursos educativos. gRPC se reserva para una necesidad comprobada de llamadas internas; async para tareas largas futuras; GraphQL no se introduce sin consumidores con requisitos divergentes. Tutor y evaluación representan recursos de creación, con respuestas 201 y revisión docente del borrador.

Antes de merge: lint sin avisos, tipos regenerados, compilación del cliente, pruebas de contrato y ejemplos contra Prism. La aprobación de un compañero sigue el DoD del equipo.
