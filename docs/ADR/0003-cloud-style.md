# ADR 0003 - Estilo Cloud AulaViva

## Estado

Aceptado

## Contexto

AulaViva es una plataforma educativa SaaS multi-tenant que requiere soportar múltiples colegios, usuarios concurrentes e integración con servicios de inteligencia artificial.

La arquitectura debe permitir escalabilidad, disponibilidad y facilidad de mantenimiento, evitando una complejidad operacional innecesaria.

Además, algunos componentes, como el Tutor IA, pueden requerir necesidades de procesamiento y escalamiento diferentes al resto de la plataforma.

## Decisión

Se adopta un estilo de arquitectura monolito modular con enfoque híbrido, apoyado en servicios administrados de AWS.

La solución utilizará AWS como proveedor cloud y estará compuesta por:

- Aplicación Web desplegada como servicio administrado.
- Backend API implementado como monolito modular y ejecutado mediante contenedores.
- Base de datos PostgreSQL administrada.
- Servicio Tutor IA separado del backend principal.
- Servicios administrados para almacenamiento y notificaciones.

Esta decisión permite mantener una arquitectura simple y fácil de operar, conservando una separación clara entre responsabilidades y permitiendo escalar de manera independiente los componentes que lo requieran.

## Alternativas consideradas

### 1. Monolito tradicional

Ventajas:

- Menor complejidad inicial.
- Desarrollo y despliegue más rápidos.
- Menor carga operacional.

Desventajas:

- Mayor acoplamiento entre funcionalidades.
- Dificulta el escalamiento independiente de componentes.
- Puede dificultar la evolución de la plataforma a medida que crece.

Motivo de descarte:

Se descartó debido a que AulaViva requiere una mejor separación entre responsabilidades y la posibilidad de aislar componentes como el Tutor IA.

### 2. Microservicios completos

Ventajas:

- Escalamiento independiente de cada servicio.
- Mayor separación de responsabilidades.
- Permite despliegues independientes.

Desventajas:

- Mayor complejidad operacional.
- Requiere mayor infraestructura y monitoreo.
- Aumenta la complejidad de comunicación entre servicios.
- Puede introducir problemas de consistencia distribuida.

Motivo de descarte:

Se consideró una solución sobredimensionada para el estado actual de AulaViva, ya que agrega complejidad operacional que aún no se justifica.

### 3. Serverless

Ventajas:

- Escalamiento automático.
- Menor administración de servidores.
- Permite utilizar recursos según demanda.

Desventajas:

- Mayor dependencia del proveedor cloud.
- Puede complicar procesos con cargas constantes.
- Puede introducir restricciones adicionales en la ejecución de algunos componentes.

Motivo de descarte:

No se considera necesario implementar toda la plataforma bajo un modelo serverless, ya que se prioriza el uso de contenedores para el backend principal.

## Consecuencias positivas

- Escalabilidad gradual según el crecimiento de la plataforma.
- Menor carga operacional al utilizar servicios administrados.
- Facilita la integración con servicios de inteligencia artificial.
- Mantiene una separación clara entre responsabilidades.
- Permite escalar el Tutor IA de manera independiente.
- Facilita una futura evolución hacia servicios separados si fuese necesario.

## Consecuencias negativas

- Dependencia parcial del proveedor AWS.
- Costos asociados al uso de servicios administrados.
- El backend principal mantiene un ciclo de despliegue compartido.
- Requiere una correcta definición de módulos para evitar acoplamiento excesivo.
- Un crecimiento significativo podría requerir separar nuevos servicios.

## Trade-offs

La decisión prioriza la simplicidad operacional, la mantenibilidad y la rapidez de desarrollo frente a la independencia total que entregaría una arquitectura de microservicios.

Se acepta que parte del backend comparta recursos y ciclos de despliegue, a cambio de reducir la complejidad de infraestructura y monitoreo.

También se acepta una dependencia parcial de AWS por el uso de servicios administrados, a cambio de disminuir las tareas de operación y mantenimiento.

El Tutor IA se mantiene separado para permitir su escalamiento independiente sin dividir prematuramente toda la plataforma en microservicios.
