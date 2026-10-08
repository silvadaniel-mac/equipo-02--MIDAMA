# Preparación preliminar S06

Modelo conceptual, pendiente de revisión del equipo y de diseño físico:

| Entidad | Relaciones y restricciones |
| --- | --- |
| Colegio | Tenant propietario de cursos, usuarios y datos académicos |
| Usuario | Membresía por colegio con rol; separar identidad de membresía |
| Curso | Pertenece a colegio; docentes asignados y estudiantes matriculados |
| Matrícula | Une estudiante y curso dentro del mismo colegio |
| Vínculo apoderado | Une apoderado y estudiante autorizado dentro del colegio |
| Contenido | Pertenece a curso y colegio; URI de archivo, autor y fecha |
| Nota | Pertenece a estudiante, asignatura y colegio; score 1–7 |
| Consulta tutor | Pertenece a curso y solicitante; referencias a contenido contextual |
| Evaluación | Borrador con preguntas; depende de contenidos y revisión docente |
| Registro idempotencia | Clave única por tenant/usuario/operación, hash, respuesta, expiración |

Reporte es una proyección de notas y asistencia (asistencia se modelará en S06). Usar claves compuestas o restricciones que impidan referencias entre tenants; considerar Row Level Security en PostgreSQL.

## Patrones para revisar

Outbox registra cambio de negocio y evento en la misma transacción, luego un publicador entrega el evento con consumidores idempotentes. Evita perder notificaciones entre persistencia y mensajería.

Saga coordina procesos distribuidos mediante pasos y compensaciones; no equivale a una transacción ACID. Evaluar solo cuando existan servicios y operaciones que deban compensarse.

CQRS separa modelos de escritura y lectura. El panel académico podría tener proyecciones con consistencia eventual; no se introduce infraestructura adicional solo por el patrón. Estas son hipótesis para S06, no decisiones aprobadas.
