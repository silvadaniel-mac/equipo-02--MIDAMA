Feature: Gestión de cursos y usuarios con roles

Scenario: Feliz - Coordinador asigna permisos a un usuario
Given el coordinador académico tiene permisos administrativos
When registra un usuario y asigna un rol
Then el sistema crea la cuenta con los permisos correspondientes


Scenario: Borde - Usuario intenta acceder a una función restringida
Given un usuario tiene asignado un rol dentro de AulaViva
When intenta ingresar a una función que no corresponde a su rol
Then el sistema bloquea el acceso
And mantiene la seguridad de la información


Scenario: Error - Error al guardar permisos de usuario
Given el coordinador modifica los permisos de un usuario
When ocurre un problema durante el guardado de información
Then el sistema informa que no fue posible actualizar los permisos
