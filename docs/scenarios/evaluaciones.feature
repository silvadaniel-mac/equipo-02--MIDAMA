Feature: Evaluaciones automáticas

Scenario: Feliz - Docente genera una evaluación automática
Given el docente tiene contenidos cargados en un curso
When solicita crear una evaluación automática
Then el sistema genera preguntas relacionadas con los contenidos


Scenario: Borde - Docente intenta crear una evaluación con poco contenido
Given el docente tiene un curso con contenido limitado
When solicita generar una evaluación automática
Then el sistema genera una evaluación limitada
And solicita agregar más contenido para mejorar los resultados


Scenario: Error - Fallo en la generación de evaluación
Given el docente solicita crear una evaluación automática
And ocurre una falla en el servicio de generación
When el sistema intenta procesar la solicitud
Then informa que no fue posible generar la evaluación
And permite volver a intentarlo
