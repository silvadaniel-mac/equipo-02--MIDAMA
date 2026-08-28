Feature: Panel de seguimiento para apoderados

Scenario: Feliz - Apoderado revisa avance académico
Given el apoderado tiene una cuenta registrada
And existe un estudiante asociado
When ingresa al panel de seguimiento
Then visualiza el avance académico del estudiante


Scenario: Borde - Estudiante sin evaluaciones registradas
Given el apoderado tiene acceso al panel
And el estudiante aún no posee evaluaciones realizadas
When consulta el avance académico
Then el sistema muestra que no existen datos disponibles


Scenario: Error - Fallo al cargar información académica
Given el apoderado intenta acceder al panel
And ocurre una falla del servidor
When solicita visualizar el progreso del estudiante
Then el sistema informa que no puede cargar la información temporalmente
