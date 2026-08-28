Feature: Seguridad multi-tenant y protección de datos

Scenario: Feliz - Sostenedor administra establecimientos autorizados
Given el sostenedor tiene acceso autorizado a AulaViva
And posee establecimientos registrados
When ingresa a la plataforma
Then puede administrar la información de sus establecimientos


Scenario: Borde - Usuario intenta consultar datos de otro establecimiento
Given un usuario pertenece a un establecimiento específico
When intenta acceder a información de otro establecimiento
Then el sistema bloquea la solicitud
And mantiene aislados los datos entre instituciones


Scenario: Error - Fallo en control de acceso
Given un usuario intenta acceder a información protegida
And ocurre un error durante la validación de permisos
When el sistema procesa la solicitud
Then registra el evento de seguridad
And rechaza el acceso a la información
