# ADR 0003 - Estilo Cloud AulaViva

## Estado

Aceptado


## Contexto

AulaViva es una plataforma educativa SaaS multi-tenant que requiere soportar múltiples colegios, usuarios concurrentes e integración con servicios de inteligencia artificial.

La arquitectura debe permitir escalabilidad, disponibilidad y facilidad de mantenimiento, evitando una complejidad operacional innecesaria.


## Decisión

Se adopta un estilo de arquitectura cloud modular con servicios administrados.

La solución utilizará AWS como proveedor cloud y estará compuesta por:

- Aplicación Web desplegada como servicio administrado.
- Backend API ejecutado mediante contenedores.
- Base de datos PostgreSQL administrada.
- Servicio Tutor IA separado.
- Servicios externos gestionados para almacenamiento y notificaciones.


## Alternativas consideradas


### 1. Monolito tradicional

Ventajas:
- Menor complejidad inicial.
- Desarrollo más rápido.

Desventajas:
- Difícil escalar componentes individuales.
- Mayor acoplamiento entre funcionalidades.


### 2. Microservicios completos

Ventajas:
- Escalamiento independiente.
- Mayor separación de responsabilidades.

Desventajas:
- Mayor complejidad operacional.
- Requiere mayor infraestructura y monitoreo.


### 3. Serverless

Ventajas:
- Escalamiento automático.
- Menor administración de servidores.

Desventajas:
- Mayor dependencia del proveedor cloud.
- Puede complicar procesos con cargas constantes.


## Consecuencias positivas

- Escalabilidad gradual según crecimiento.
- Menor carga operacional al utilizar servicios administrados.
- Facilita integración con inteligencia artificial.
- Mantiene separación entre responsabilidades.


## Consecuencias negativas

- Dependencia parcial del proveedor AWS.
- Costos asociados al uso de servicios administrados.
- Requiere configuración adecuada de servicios cloud.
