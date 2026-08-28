Feature: Tutor IA contextualizado

Scenario: Feliz - Estudiante recibe respuesta del tutor IA
Given el estudiante tiene acceso a un curso activo
And el curso posee contenidos cargados en AulaViva
When el estudiante realiza una pregunta relacionada con la materia
Then el tutor IA entrega una respuesta basada en los contenidos del curso


Scenario: Borde - Estudiante realiza una pregunta fuera del contenido disponible
Given el estudiante tiene acceso al tutor IA
And realiza una pregunta que no está incluida en los contenidos del curso
When envía la consulta al tutor IA
Then el sistema indica que no posee información suficiente para responder


Scenario: Error - Tutor IA presenta una falla
Given el estudiante intenta utilizar el tutor IA
And el servicio de inteligencia artificial no está disponible
When envía una pregunta al sistema
Then AulaViva informa que el tutor IA presenta problemas temporalmente
And permite utilizar otras funcionalidades de la plataforma
