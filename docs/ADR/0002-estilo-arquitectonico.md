# ADR 0002 - Estilo Arquitectónico AulaViva

## Estado

Aceptado


## Contexto

AulaViva es una plataforma educativa SaaS con inteligencia artificial orientada a colegios.

El sistema debe permitir gestionar múltiples establecimientos, usuarios, evaluaciones y consultas mediante un Tutor IA.

La arquitectura debe permitir crecimiento futuro, facilidad de mantenimiento e integración con nuevos servicios.


## Decisión

Se decide utilizar una arquitectura modular desacoplada compuesta por:

- Aplicación Web Frontend
- Backend API
- Base de Datos
- Servicio Tutor IA
- Servicios externos de comunicación


Esta separación permite que cada módulo pueda evolucionar de forma independiente.


## Alternativas consideradas


### 1. Arquitectura monolítica

Ventajas:

- Desarrollo inicial más rápido.
- Menor complejidad inicial.

Desventajas:

- Dificultad para escalar componentes específicos.
- Mayor dependencia entre funcionalidades.


### 2. Arquitectura basada en microservicios completos

Ventajas:

- Alta escalabilidad.
- Independencia total entre servicios.

Desventajas:

- Mayor complejidad operacional.
- Requiere más infraestructura.


## Decisión final

Se selecciona una arquitectura modular desacoplada, manteniendo separación entre frontend, backend, base de datos y servicios de inteligencia artificial.


## Consecuencias positivas

- Permite escalar el Tutor IA de manera independiente.
- Facilita mantenimiento y actualización.
- Mejora la organización del sistema.
- Permite incorporar nuevos colegios mediante modelo multi-tenant.


## Consecuencias negativas

- Mayor complejidad inicial comparada con un monolito.
- Requiere definir correctamente las interfaces entre módulos.
