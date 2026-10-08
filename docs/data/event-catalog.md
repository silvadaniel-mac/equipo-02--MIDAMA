# Catálogo de Eventos de Dominio — AulaViva

**Proyecto:** AulaViva — Plataforma Educativa SaaS  
**Equipo:** MIDAMA  
**Sesión:** S06 — Modelo de Datos y Eventos  
**Versión del catálogo:** 1.0

---

## 1. Introducción

AulaViva utiliza eventos de dominio para representar cambios importantes en sus procesos académicos y administrativos.

Un evento de dominio representa un hecho que ya ocurrió dentro del sistema. Por ejemplo, cuando un estudiante termina una evaluación, se genera el evento `evaluacion.intento.entregado`.

El catálogo define 15 eventos propuestos para permitir la comunicación entre los cuatro Bounded Contexts identificados.

## 2. Formato de los eventos

Los eventos seguirán la convención:

`recurso.accion.resultado_pasado`

Cada evento tendrá los siguientes atributos comunes:

| Campo | Tipo | Descripción |
|---|---|---|
| event_id | UUID | Identificador único del evento |
| event_type | String | Nombre del evento |
| version | Integer | Versión del esquema |
| occurred_at | Timestamp | Fecha y hora del suceso |
| tenant_id | UUID | Identificador del establecimiento |
| payload | Object | Datos específicos del evento |

Todos los eventos definidos inicialmente utilizan la versión `1`.

## 3. Catálogo de eventos

### BC1 — Identidad y Establecimientos

| Evento | Versión | Campos del payload | Productor | Consumidor |
|---|---|---|---|---|
| establecimiento.creacion.completada | 1 | establecimiento_id, nombre | Identidad | Gestión Académica |
| usuario.registro.completado | 1 | usuario_id, rol_inicial | Identidad | Gestión Académica |
| usuario.rol.asignado | 1 | usuario_id, rol | Identidad | Gestión Académica |

Estos eventos permiten informar sobre establecimientos, registros de usuarios y cambios en los permisos de acceso.

### BC2 — Gestión Académica

| Evento | Versión | Campos del payload | Productor | Consumidor |
|---|---|---|---|---|
| curso.creacion.completada | 1 | curso_id, asignatura_id | Gestión Académica | Contenidos y Tutor IA, Evaluaciones |
| estudiante.matricula.confirmada | 1 | matricula_id, curso_id, estudiante_id | Gestión Académica | Evaluaciones, Tutor IA |
| docente.curso.asignado | 1 | curso_id, docente_id | Gestión Académica | Evaluaciones |

Estos eventos informan los cambios en la organización académica y permiten relacionar estudiantes, docentes y cursos.

### BC3 — Contenidos y Tutor IA

| Evento | Versión | Campos del payload | Productor | Consumidor |
|---|---|---|---|---|
| contenido.publicacion.completada | 1 | contenido_id, curso_id, titulo | Contenidos y Tutor IA | Evaluaciones |
| documento.indexacion.completada | 1 | documento_id, contenido_id, indice_version | Contenidos y Tutor IA | Evaluaciones |
| tutoria.sesion.iniciada | 1 | sesion_id, estudiante_id, curso_id | Contenidos y Tutor IA | Evaluaciones y Seguimiento |
| tutoria.consulta.respondida | 1 | sesion_id, consulta_id, modelo_version | Contenidos y Tutor IA | Evaluaciones y Seguimiento |

Estos eventos permiten registrar la disponibilidad de materiales educativos y el uso del Tutor IA.

La indexación de documentos se relaciona con el procesamiento de información utilizado por la base vectorial de AulaViva.

### BC4 — Evaluaciones y Seguimiento

| Evento | Versión | Campos del payload | Productor | Consumidor |
|---|---|---|---|---|
| evaluacion.creacion.completada | 1 | evaluacion_id, docente_id, curso_id | Evaluaciones | Gestión Académica |
| evaluacion.asignacion.completada | 1 | asignacion_id, evaluacion_id, curso_id, fecha_limite | Evaluaciones | Gestión Académica |
| evaluacion.intento.iniciado | 1 | intento_id, asignacion_id, estudiante_id | Evaluaciones | Seguimiento académico |
| evaluacion.intento.entregado | 1 | intento_id, fecha_entrega | Evaluaciones | Calificación y Seguimiento |
| evaluacion.calificacion.registrada | 1 | calificacion_id, intento_id, nota, porcentaje | Evaluaciones | Gestión Académica, Notificaciones |

Estos eventos representan el ciclo de vida principal de una evaluación, desde su creación hasta el registro de la calificación.

## 4. Flujo principal de eventos

El proceso de evaluación de AulaViva seguirá conceptualmente esta secuencia:

**1. Creación de curso:** Se registra un curso en Gestión Académica.

**2. Matrícula:** Un estudiante se matricula en el curso.

**3. Publicación de contenido:** Un docente publica material educativo.

**4. Creación de evaluación:** Se crea una evaluación relacionada con el contenido del curso.

**5. Asignación:** La evaluación queda disponible para los estudiantes correspondientes.

**6. Inicio de intento:** El estudiante comienza a responder la evaluación.

**7. Entrega:** El estudiante finaliza y entrega sus respuestas.

**8. Calificación:** El sistema registra el resultado obtenido.

**9. Seguimiento:** Los resultados quedan disponibles para generar indicadores de progreso académico.

## 5. Reglas y consideraciones técnicas

**Versionado:** Cada evento incluye una versión para permitir la evolución de su estructura sin afectar innecesariamente a los consumidores existentes.

**Desacoplamiento:** Los contextos productores no necesitan conocer la implementación interna de los consumidores.

**Seguridad:** Los eventos incorporan `tenant_id` para identificar el establecimiento al que pertenecen. Los consumidores deben validar su autorización antes de procesar datos de un establecimiento.

**Privacidad:** Los mensajes deberán contener solamente la información necesaria, evitando incluir respuestas completas del Tutor IA o datos personales sensibles cuando no sean indispensables.

**Idempotencia:** Los consumidores deberán evitar procesar dos veces el mismo evento mediante su identificador `event_id`.

**Consistencia:** Se evaluará el patrón Transactional Outbox para publicar eventos asociados a cambios persistidos en la base de datos.

**Estado de implementación:** El catálogo representa el diseño propuesto para S06. No implica que todos estos eventos ya se encuentren implementados.

## 6. Conclusión

Se definieron 15 eventos de dominio distribuidos entre los cuatro Bounded Contexts de AulaViva.

Los eventos permiten representar procesos importantes, como la creación de cursos, matrícula de estudiantes, publicación de contenidos, interacción con el Tutor IA y realización de evaluaciones.

Este catálogo proporciona una base para definir la comunicación asíncrona, seleccionar un broker y justificar las decisiones arquitectónicas del ADR 0004.
