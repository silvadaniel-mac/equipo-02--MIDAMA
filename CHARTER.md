### Propósito
Modernizar la experiencia de aprendizaje escolar en la Región Metropolitana mediante el desarrollo de "AulaViva", una plataforma SaaS multi-tenant que integra contenidos, evaluaciones automáticas y un tutor de IA contextualizado al currículum del MINEDUC.

### Integrantes y Roles Asignados
*Roles rotativos asignados para el primer sprint:*

*   **Product Owner (PO):** Antonella Mancilla — *Responsable de priorizar el backlog y validar el valor entregable.*
*   **Tech Lead:** Daniel Silva — *Custodio de la arquitectura del SaaS multi-tenant y los ADRs.*
*   **DevSecOps Lead:** Allen Ramirez — *Encargado de pipelines, seguridad de datos sensibles y observabilidad.*
*   **AI/Data Lead:** Miguel Briceño — *Responsable del motor RAG, features de IA generativa y optimización de costos LLM.*
*   **QA Lead:** Ian Godoy — *A cargo de la estrategia de pruebas, calidad y cumplimiento normativo.*
*   **DevSecOps:** Matias Riquelme — *Apoyo en desarrollo de seguridad de datos sensibles y observabilidad.*

### Definition of Done (DoD) Preliminar
Una tarea o *user story* se considera "Terminada" cuando cumple con lo siguiente:
1. El código ha sido revisado por al menos un par (Code Review).
2. Pasa automáticamente todas las pruebas unitarias y de integración.
3. Se han validado los criterios de aceptación definidos por el PO.
4. La funcionalidad IA (si aplica) ha pasado controles de contexto (RAG) y guardrails.
5. Cumple con la política de seguridad y privacidad (aislamiento de datos por tenant).

### Política de Uso de IA
**El uso de IA generativa está permitido y es esperado en este equipo.**
*   **Transparencia:** El uso de IA generativa está permitido y es esperado, pero debe declararse obligatoriamente en los mensajes de commit. Esto garantiza la honestidad en el equipo y facilita rastrear el origen de cada componente en el repositorio.  
*   **Cero copias ciegas:** Copiar y pegar código generado por IA sin comprender su funcionamiento lógico será estrictamente penalizado. Cada integrante debe ser capaz de explicar su solución línea por línea, ya que el pensamiento crítico es irremplazable.
*   **Auditoría obligatoria:** Toda contribución que haya sido asistida por Inteligencia Artificial será auditada por el equipo durante el proceso de Code Review. Esta revisión grupal asegura que el código cumpla con los estándares de calidad antes de integrarse al producto final.
*   **Privacidad estricta:** Queda absolutamente prohibido ingresar datos reales de estudiantes, contraseñas o API keys en los prompts de la IA. Al desarrollar una plataforma para menores, protegeremos la privacidad utilizando exclusivamente datos ficticios y de prueba.
*   Responsabilidad total: El desarrollador que envía el Pull Request asume el cien por ciento de la responsabilidad sobre el código entregado. La IA opera únicamente como un asistente, por lo que el autor humano debe responder por el rendimiento y la seguridad.
*   **Seguridad:** Asumimos por defecto que la IA puede sufrir alucinaciones o introducir vulnerabilidades ocultas. Por ello, todo código automatizado debe atravesar y superar rigurosamente nuestros filtros de QA y escaneos de seguridad.
*   **Uso recomendado:** Fomentamos el uso estratégico de la IA para agilizar tareas repetitivas, crear bases de código (boilerplates) y generar datos de prueba. Esto nos permite concentrar nuestra energía intelectual en la arquitectura y las decisiones complejas del proyecto.


### Acuerdos de Trabajo y Comunicación
*   **Canal Principal:** Discord (Canal: `#equipo-aulaviva-dev`).
*   **Cadencia de Reuniones:**
    *   Dailies asíncronas vía Discord a las 09:30 hrs.
    *   Reunión de Planning y Refinamiento los lunes a las 10:00 hrs.
    *   Retrospectiva los viernes a las 15:00 hrs.


**Consecuencias (Restricciones y Retos asumidos):**
Al elegir esta iniciativa, el equipo asume los siguientes compromisos arquitectónicos y de desarrollo:
1.  **Diseño Multi-tenant Estricto:** Deberemos diseñar una base de datos y backend que garantice el aislamiento absoluto de los datos por colegio (tenant).
2.  **Manejo de Datos Sensibles:** Implementaremos políticas especiales de privacidad y enmascaramiento al tratar con datos de menores de edad.
3.  **Escalabilidad Estacional:** La arquitectura deberá soportar picos brutales de tráfico durante periodos de pruebas escolares, requiriendo un escalado horizontal eficiente.
4.  **Optimización FinOps:** El uso continuo del LLM por múltiples tenants requerirá una monitorización estricta de costos.

**Fecha:** 17 de agosto de 2026.

**Autores:** Equipo de Desarrollo AulaViva (Antonella, Daniel, Allen, Miguel, Ian, Matias).
