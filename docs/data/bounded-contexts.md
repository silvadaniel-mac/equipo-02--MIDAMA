# Bounded Contexts — AulaViva

**Proyecto:** AulaViva — Plataforma Educativa SaaS  
**Equipo:** MIDAMA  
**Sesión:** S06 — Modelo de Datos y Eventos  
**Metodología:** Domain-Driven Design (DDD)

---

## 1. Introducción

AulaViva es una plataforma educativa SaaS diseñada para facilitar la gestión académica, las evaluaciones automatizadas y el aprendizaje mediante inteligencia artificial.

Para mantener una arquitectura organizada, escalable y fácil de mantener, se identificaron cuatro Bounded Contexts siguiendo los principios de Domain-Driven Design (DDD).

Un Bounded Context representa un límite lógico dentro del sistema, donde se agrupan funcionalidades, entidades y reglas de negocio relacionadas.

Esta separación permite que cada contexto tenga responsabilidades claramente definidas, evitando dependencias innecesarias entre los diferentes componentes de AulaViva.

## 2. Bounded Contexts identificados

### BC1 — Identidad y Establecimientos

**Responsabilidad:** Administrar los establecimientos educativos, usuarios, roles y permisos de acceso.

**Entidades principales:**
- Establecimiento
- Usuario
- Rol
- Permiso

**Funcionalidades:**
- Registro y administración de usuarios.
- Autenticación y autorización.
- Asignación de roles y permisos.
- Administración de establecimientos educativos.
- Aislamiento de información entre establecimientos mediante multi-tenancy.

**Justificación:**

Este contexto permite centralizar la seguridad y la administración de usuarios, garantizando que cada establecimiento educativo pueda gestionar sus propios datos sin acceder a información de otros establecimientos.

### BC2 — Gestión Académica

**Responsabilidad:** Administrar la estructura académica de los establecimientos educativos.

**Entidades principales:**
- Curso
- Asignatura
- Matrícula
- Asignación Docente

**Funcionalidades:**
- Creación y administración de cursos.
- Gestión de asignaturas.
- Asignación de docentes a cursos.
- Inscripción de estudiantes mediante matrículas.
- Organización de la estructura académica.

**Justificación:**

Este contexto concentra las operaciones académicas de AulaViva, permitiendo administrar cursos y asignaturas independientemente de la gestión de usuarios, evaluaciones y herramientas de inteligencia artificial.

### BC3 — Contenidos y Tutor IA

**Responsabilidad:** Gestionar recursos educativos y proporcionar asistencia personalizada mediante inteligencia artificial.

**Entidades principales:**
- Contenido Educativo
- Documento
- Sesión de Tutoría
- Consulta IA

**Funcionalidades:**
- Administración de materiales educativos.
- Almacenamiento y consulta de documentos.
- Interacción con el Tutor IA.
- Generación de respuestas educativas personalizadas.
- Búsqueda de información mediante bases de datos vectoriales.

**Justificación:**

Este contexto permite separar las funcionalidades de inteligencia artificial del resto del sistema, facilitando su mantenimiento, evolución tecnológica e integración con herramientas especializadas.

### BC4 — Evaluaciones y Seguimiento

**Responsabilidad:** Gestionar evaluaciones académicas, respuestas de estudiantes, calificaciones y seguimiento del aprendizaje.

**Entidades principales:**
- Evaluación
- Pregunta
- Intento
- Respuesta
- Calificación

**Funcionalidades:**
- Creación y administración de evaluaciones.
- Generación automática de preguntas.
- Registro de respuestas de estudiantes.
- Corrección automática de evaluaciones.
- Registro de calificaciones.
- Seguimiento del progreso académico.
- Generación de informes para docentes y apoderados.

**Justificación:**

Este contexto centraliza el proceso de evaluación académica, permitiendo registrar resultados y analizar el rendimiento de los estudiantes sin mezclar estas responsabilidades con la administración de cursos o usuarios.

---

## 3. Mapa de Bounded Contexts

Los cuatro contextos mantienen responsabilidades independientes, pero deben comunicarse para permitir el funcionamiento completo de AulaViva.

### Relaciones entre contextos

| Contexto origen | Contexto destino | Información compartida |
|---|---|---|
| Identidad y Establecimientos | Gestión Académica | Usuarios, roles e identificadores de establecimientos |
| Gestión Académica | Contenidos y Tutor IA | Cursos, asignaturas y referencias académicas |
| Gestión Académica | Evaluaciones y Seguimiento | Cursos, estudiantes y matrículas |
| Contenidos y Tutor IA | Evaluaciones y Seguimiento | Referencias a contenidos educativos |
| Evaluaciones y Seguimiento | Gestión Académica | Resultados y progreso académico |

### Descripción del flujo

1. **Identidad y Establecimientos** proporciona la información necesaria para identificar a los usuarios y sus permisos.
2. **Gestión Académica** organiza los cursos, asignaturas y matrículas de los estudiantes.
3. **Contenidos y Tutor IA** utiliza referencias académicas para entregar asistencia educativa personalizada.
4. **Evaluaciones y Seguimiento** administra las evaluaciones y registra el progreso de los estudiantes.
5. Los resultados académicos pueden ser consultados por otros contextos mediante interfaces autorizadas.

Cada contexto mantiene la responsabilidad sobre sus propios datos y reglas de negocio.

---

## 4. Comunicación entre contextos

Para permitir la integración entre los Bounded Contexts, se consideran los siguientes mecanismos de comunicación:

### Comunicación síncrona

Se utilizarán APIs REST cuando un contexto necesite consultar información de otro y requiera una respuesta inmediata.

**Ejemplo:**

El contexto de Evaluaciones y Seguimiento consulta a Gestión Académica para verificar que un estudiante pertenece a un curso.

### Comunicación asíncrona

Se propone utilizar eventos de dominio para comunicar cambios importantes sin generar dependencias directas entre los contextos.

**Ejemplos de eventos:**
- UsuarioRegistrado
- EstudianteMatriculado
- ContenidoPublicado
- EvaluacionCreada
- EvaluacionCompletada
- CalificacionRegistrada

Estos eventos son propuestas iniciales que serán formalizadas en el catálogo de eventos de la sesión S06.

---

## 5. Consideraciones Arquitectónicas

Los Bounded Contexts representan límites lógicos del negocio y no requieren necesariamente microservicios independientes.

AulaViva mantiene una arquitectura modular, donde los diferentes contextos pueden implementarse mediante módulos separados dentro del backend principal.

Se consideran las siguientes decisiones:

- Mantener responsabilidades y reglas de negocio independientes.
- Evitar modificaciones directas sobre datos pertenecientes a otros contextos.
- Utilizar APIs para consultas que requieren respuestas inmediatas.
- Evaluar eventos de dominio para procesos asíncronos.
- Respetar el aislamiento de datos por establecimiento.
- Facilitar futuras mejoras sin afectar los demás módulos.

Estas decisiones deben mantenerse alineadas con la arquitectura C4 y los ADR existentes del proyecto.

---

## 6. Conclusión

Se identificaron cuatro Bounded Contexts principales para AulaViva: Identidad y Establecimientos, Gestión Académica, Contenidos y Tutor IA, y Evaluaciones y Seguimiento.

Esta división permite organizar las funcionalidades del sistema según sus responsabilidades, mejorar la mantenibilidad y reducir el acoplamiento entre sus componentes.

Además, proporciona una base para desarrollar el modelo entidad-relación (DER), el catálogo de eventos de dominio y el ADR 0004, correspondientes a la sesión S06.
