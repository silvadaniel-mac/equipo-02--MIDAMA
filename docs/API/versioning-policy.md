# Política de Versionado y Depreciación

### 1. Versionado

* Utilizamos versionado en la URL (URI Versioning).
* La versión principal de la API es la `v1` (ejemplo: `/api/v1/...`).
* Los cambios que rompan la compatibilidad (Breaking Changes) forzarán la creación de una nueva versión mayor (ejemplo: `/api/v2/...`).
* Los cambios menores (como agregar campos nuevos) se harán sobre la versión actual sin afectar a los clientes existentes.

### 2. Política de Depreciación

* Cuando un endpoint o propiedad quede obsoleto, se marcará con la etiqueta `deprecated: true` en el contrato OpenAPI.
* Se notificará a los consumidores de la API con un mínimo de **3 meses de anticipación** antes de dar de baja el recurso de forma definitiva.
* Durante este periodo de gracia, el endpoint obsoleto seguirá funcionando exactamente igual, pero las respuestas incluirán una advertencia para que los equipos planifiquen su migración.
