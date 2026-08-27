# Impact Map - AulaViva

## Goal (Objetivo de negocio)

Modernizar la experiencia de aprendizaje escolar en la Región Metropolitana mediante una plataforma SaaS multi-tenant que permita a colegios gestionar contenidos, evaluaciones automáticas y aprendizaje asistido por IA contextualizada al currículum MINEDUC.

---

# Actors

## 1. Estudiante

### Impactos esperados

- Acceder a contenidos educativos personalizados.
- Resolver dudas mediante un tutor IA contextualizado.
- Mejorar su rendimiento académico mediante retroalimentación inmediata.

### Deliverables

- Tutor IA con RAG basado en contenidos del curso.
- Biblioteca de contenidos educativos.
- Sistema de evaluaciones con feedback automático.

---

## 2. Docente

### Impactos esperados

- Reducir tiempo dedicado a crear evaluaciones.
- Obtener información sobre avances y dificultades.
- Personalizar estrategias de enseñanza.

### Deliverables

- Generador de evaluaciones automáticas.
- Gestión de cursos y estudiantes.
- Panel de seguimiento académico.

---

## 3. Coordinador académico

### Impactos esperados

- Supervisar el desempeño general de los cursos.
- Gestionar la implementación tecnológica del colegio.
- Tomar decisiones basadas en datos.

### Deliverables

- Dashboard institucional.
- Reportes académicos.
- Gestión de usuarios y permisos.

---

## 4. Apoderado

### Impactos esperados

- Conocer el progreso académico del estudiante.
- Participar activamente en el proceso educativo.

### Deliverables

- Panel del apoderado.
- Visualización de avance y evaluaciones.

---

## 5. Sostenedor

###Impactos esperados

- Administrar múltiples establecimientos educativos de forma segura.
- Garantizar la privacidad y protección de los datos personales de estudiantes y docentes.
- Asegurar el aislamiento de información entre instituciones.
- Cumplir con normativas de ciberseguridad y protección de datos
  
### Deliverables

- Arquitectura SaaS multi-tenant con aislamiento lógico de datos.
- Sistema RBAC para control de permisos según roles.
- Gestión segura de usuarios y establecimientos.
- Registro de auditoría y monitoreo de accesos.
- Políticas de seguridad y protección de datos.
---

# Relaciones principales

## Goal → Estudiante

Impact:
Recibir aprendizaje personalizado.

Deliverable:
Tutor IA RAG + contenidos educativos.


## Goal → Docente

Impact:
Reducir carga administrativa.

Deliverable:
Evaluaciones automáticas + gestión académica.


## Goal → Colegio

Impact:
Gestionar información educativa segura.

Deliverable:
Plataforma SaaS multi-tenant con aislamiento lógico.
