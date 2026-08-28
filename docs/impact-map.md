# Impact Map - AulaViva

## Goal (Objetivo de negocio)

Modernizar la experiencia de aprendizaje escolar en la Región Metropolitana mediante una plataforma SaaS multi-tenant que permita a los colegios gestionar contenidos educativos, evaluaciones automáticas y aprendizaje asistido mediante un tutor IA contextualizado al currículum MINEDUC.

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
- Sistema de evaluaciones con retroalimentación automática.

### Historias relacionadas

- Historia 1: Tutor IA contextualizado.
- Historia 2: Evaluaciones automáticas.

---

## 2. Docente

### Impactos esperados

- Reducir el tiempo dedicado a crear y corregir evaluaciones.
- Obtener información sobre avances y dificultades de los estudiantes.
- Personalizar estrategias de enseñanza según las necesidades detectadas.

### Deliverables

- Generador de evaluaciones automáticas.
- Gestión de cursos y estudiantes.
- Panel de seguimiento académico.

### Historias relacionadas

- Historia 2: Evaluaciones automáticas.
- Historia 3: Gestión de cursos y usuarios con roles.

---

## 3. Coordinador académico

### Impactos esperados

- Supervisar el desempeño general de los cursos.
- Gestionar usuarios, permisos y organización académica.
- Tomar decisiones basadas en información del rendimiento estudiantil.

### Deliverables

- Dashboard institucional.
- Reportes académicos.
- Sistema de gestión de usuarios y permisos.

### Historias relacionadas

- Historia 3: Gestión de cursos y usuarios con roles.

---

## 4. Apoderado

### Impactos esperados

- Conocer el progreso académico del estudiante.
- Participar activamente en el acompañamiento educativo.
- Detectar dificultades de aprendizaje oportunamente.

### Deliverables

- Panel del apoderado.
- Visualización de avance académico.
- Información de evaluaciones y progreso del estudiante.

### Historias relacionadas

- Historia 4: Panel de seguimiento para apoderados.

---

## 5. Sostenedor

### Impactos esperados

- Administrar múltiples establecimientos educativos de forma segura.
- Garantizar la privacidad y protección de los datos personales de estudiantes y docentes.
- Mantener el aislamiento de información entre instituciones.
- Cumplir requisitos de ciberseguridad y protección de datos.

### Deliverables

- Arquitectura SaaS multi-tenant con aislamiento lógico de datos.
- Sistema RBAC para control de permisos según roles.
- Gestión segura de usuarios y establecimientos.
- Registro de auditoría y monitoreo de accesos.
- Políticas de seguridad y protección de datos.

### Historias relacionadas

- Historia 5: Seguridad multi-tenant y protección de datos.
- Historia 3: Gestión de cursos y usuarios con roles.

---

# Relaciones principales

## Goal → Estudiante

**Impacto:**  
Recibir aprendizaje personalizado y apoyo inmediato durante su proceso educativo.

**Deliverable:**  
Tutor IA RAG, contenidos educativos y sistema de retroalimentación.

**Historia relacionada:**  
Historia 1: Tutor IA contextualizado.

---

## Goal → Docente

**Impacto:**  
Reducir carga administrativa y mejorar la gestión del aprendizaje.

**Deliverable:**  
Evaluaciones automáticas y herramientas de gestión académica.

**Historia relacionada:**  
Historia 2: Evaluaciones automáticas.

---

## Goal → Coordinador académico

**Impacto:**  
Administrar y supervisar la actividad educativa mediante información organizada.

**Deliverable:**  
Gestión de cursos, usuarios y permisos.

**Historia relacionada:**  
Historia 3: Gestión de cursos y usuarios con roles.

---

## Goal → Apoderado

**Impacto:**  
Participar activamente en el seguimiento del aprendizaje del estudiante.

**Deliverable:**  
Panel de seguimiento académico.

**Historia relacionada:**  
Historia 4: Panel de seguimiento para apoderados.

---

## Goal → Sostenedor

**Impacto:**  
Gestionar información educativa segura y proteger datos sensibles.

**Deliverable:**  
Plataforma SaaS multi-tenant con aislamiento lógico, control de acceso y auditoría.

**Historia relacionada:**  
Historia 5: Seguridad multi-tenant y protección de datos.

---

# Trazabilidad Goal → Historia

| Goal | Actor | Impacto | Deliverable | Historia |
|---|---|---|---|---|
| Modernizar la experiencia de aprendizaje escolar mediante AulaViva | Estudiante | Aprendizaje personalizado | Tutor IA RAG y contenidos educativos | Historia 1: Tutor IA contextualizado |
| Modernizar la experiencia de aprendizaje escolar mediante AulaViva | Docente | Reducción de carga administrativa | Evaluaciones automáticas y gestión académica | Historia 2: Evaluaciones automáticas |
| Modernizar la experiencia de aprendizaje escolar mediante AulaViva | Coordinador académico | Gestión organizada de usuarios y cursos | Sistema de roles y permisos | Historia 3: Gestión de cursos y usuarios con roles |
| Modernizar la experiencia de aprendizaje escolar mediante AulaViva | Apoderado | Seguimiento del avance académico | Panel de seguimiento | Historia 4: Panel de seguimiento para apoderados |
| Modernizar la experiencia de aprendizaje escolar mediante AulaViva | Sostenedor | Seguridad y protección de datos | Arquitectura multi-tenant y control de acceso | Historia 5: Seguridad multi-tenant y protección de datos |
