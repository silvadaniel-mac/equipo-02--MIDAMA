# Backlog Inicial - AulaViva

## Historia 1: Tutor IA contextualizado

### User Story

**Como estudiante,**  
quiero consultar un tutor IA basado en los contenidos de mi curso,  
para resolver dudas y mejorar mi comprensión de las materias.

---

### INVEST

| Criterio | Descripción |
|---|---|
| **I - Independent** | Puede desarrollarse como una funcionalidad independiente del sistema sin depender de otras historias. |
| **N - Negotiable** | La forma de interacción, tipo de respuestas y alcance del tutor pueden definirse junto al equipo. |
| **V - Valuable** | Entrega valor al estudiante mediante apoyo personalizado durante su aprendizaje. |
| **E - Estimable** | El equipo puede estimar el desarrollo considerando integración IA, contenidos y pruebas. |
| **S - Small** | La primera versión puede limitarse a responder consultas sobre contenidos cargados de un curso. |
| **T - Testable** | Se puede validar mediante preguntas al tutor y criterios de aceptación definidos. |

### Prioridad MoSCoW

✅ **Obligatorio**

---

# Historia 2: Evaluaciones automáticas

### User Story

**Como docente,**  
quiero generar evaluaciones automáticamente a partir de los contenidos del curso,  
para reducir el tiempo de preparación de pruebas y mejorar el proceso educativo.

---

### INVEST

| Criterio | Descripción |
|---|---|
| **I - Independent** | Puede implementarse sin depender del panel del apoderado ni del dashboard académico. |
| **N - Negotiable** | El formato, cantidad y tipo de preguntas pueden ajustarse según las necesidades del docente. |
| **V - Valuable** | Reduce la carga administrativa del profesor y facilita la evaluación del aprendizaje. |
| **E - Estimable** | El equipo puede calcular el esfuerzo necesario para generar preguntas y validar resultados. |
| **S - Small** | La primera versión puede enfocarse en generar evaluaciones básicas desde contenidos existentes. |
| **T - Testable** | Se puede comprobar si el sistema genera evaluaciones correctas según los contenidos ingresados. |

### Prioridad MoSCoW

✅ **Obligatorio**

---

# Historia 3: Gestión de cursos y usuarios con roles

### User Story

**Como coordinador académico,**  
quiero gestionar cursos, docentes y estudiantes con permisos según sus roles,  
para organizar la plataforma educativa de forma segura.

---

### INVEST

| Criterio | Descripción |
|---|---|
| **I - Independent** | Puede desarrollarse como módulo de administración sin depender del tutor IA. |
| **N - Negotiable** | Los roles y permisos pueden definirse según los requerimientos del establecimiento. |
| **V - Valuable** | Permite controlar el acceso y mantener organizada la información académica. |
| **E - Estimable** | El equipo puede estimar usuarios, roles, permisos y validaciones necesarias. |
| **S - Small** | La primera versión puede incluir roles principales: estudiante, docente y administrador. |
| **T - Testable** | Se puede verificar que cada usuario acceda solamente a las funciones permitidas. |

### Prioridad MoSCoW

✅ **Obligatorio**

---

# Historia 4: Panel de seguimiento para apoderados

### User Story

**Como apoderado,**  
quiero visualizar el avance académico del estudiante asociado,  
para participar activamente en su proceso educativo y apoyarlo oportunamente.

---

### INVEST

| Criterio | Descripción |
|---|---|
| **I - Independent** | Puede funcionar utilizando información académica ya registrada por la plataforma. |
| **N - Negotiable** | Los indicadores mostrados pueden definirse según las necesidades del colegio. |
| **V - Valuable** | Permite al apoderado conocer el progreso y detectar dificultades. |
| **E - Estimable** | El equipo puede estimar la creación del panel y la integración con datos académicos. |
| **S - Small** | La primera versión puede mostrar notas, avance y evaluaciones próximas. |
| **T - Testable** | Se puede comprobar que el apoderado visualice correctamente la información correspondiente. |

### Prioridad MoSCoW

🟡 **Importante, pero no crítico**

---

# Historia 5: Seguridad multi-tenant y protección de datos

### User Story

**Como sostenedor,**  
quiero administrar establecimientos con aislamiento de datos y control de accesos,  
para proteger la información de estudiantes y cumplir requisitos de seguridad.

---

### INVEST

| Criterio | Descripción |
|---|---|
| **I - Independent** | Puede desarrollarse como componente de seguridad y arquitectura base. |
| **N - Negotiable** | Las políticas de seguridad y permisos pueden ajustarse según normativas y necesidades. |
| **V - Valuable** | Protege datos sensibles de estudiantes y garantiza privacidad entre establecimientos. |
| **E - Estimable** | El equipo puede estimar la implementación de aislamiento, permisos y auditoría. |
| **S - Small** | La primera versión puede enfocarse en separación de datos y roles principales. |
| **T - Testable** | Se puede validar intentando acceder a información de otro establecimiento y comprobando el bloqueo. |

### Prioridad MoSCoW

✅ **Obligatorio**
