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

**Obligatorio**

**Justificación:**  
Es una funcionalidad principal de AulaViva, ya que el proyecto busca integrar un tutor IA contextualizado al currículum MINEDUC. Esta característica entrega el principal valor diferencial de la plataforma al permitir un aprendizaje personalizado.

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

**Obligatorio**

**Justificación:**  
Forma parte del alcance mínimo del producto, ya que permite a los docentes automatizar parte del proceso evaluativo y mejorar la eficiencia en la gestión del aprendizaje.

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

**Obligatorio**

**Justificación:**  
Es necesaria para el funcionamiento de la plataforma, ya que permite administrar usuarios y controlar los permisos de acceso. Además, contribuye a la seguridad y correcta organización de la información educativa.

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

**Importante, pero no crítico**

**Justificación:**  
Entrega valor al proceso educativo al permitir que los apoderados acompañen el avance del estudiante. Sin embargo, no es indispensable para la primera versión funcional del sistema, por lo que puede desarrollarse después de las funcionalidades principales del MVP.

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

**Obligatorio**

**Justificación:**  
Es un requisito fundamental debido al manejo de datos sensibles de estudiantes y establecimientos. La seguridad, el aislamiento de información entre tenants y el control de accesos son necesarios para garantizar la protección de datos dentro de AulaViva.
