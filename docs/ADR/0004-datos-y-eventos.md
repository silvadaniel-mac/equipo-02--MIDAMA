# ADR 0004 — Modelo de Datos y Arquitectura Basada en Eventos

**Proyecto:** AulaViva — Plataforma Educativa SaaS  
**Equipo:** MIDAMA  
**Sesión:** S06 — Modelo de Datos y Eventos  
**Fecha:** 08-10-2026  
**Estado:** Propuesto

---

## 1. Contexto

AulaViva es una plataforma educativa SaaS orientada a establecimientos educacionales, que permite administrar usuarios, cursos, contenidos educativos, evaluaciones y un Tutor IA.

El sistema utiliza una arquitectura modular desacoplada, definida previamente en el ADR 0002.

Durante la sesión S06 se identificaron cuatro Bounded Contexts:

1. Identidad y Establecimientos.
2. Gestión Académica.
3. Contenidos y Tutor IA.
4. Evaluaciones y Seguimiento.

Estos contextos necesitan almacenar información y comunicarse sin generar dependencias innecesarias.

Por lo tanto, se requiere definir los motores de persistencia, el broker de eventos y los patrones arquitectónicos que permitirán mantener la consistencia de los datos.

## 2. Decisiones arquitectónicas

### 2.1. Motor de persistencia relacional

**Decisión:** Utilizar PostgreSQL mediante Amazon RDS.

PostgreSQL almacenará la información estructurada de los cuatro Bounded Contexts.

Se propone utilizar inicialmente una instancia compartida, separando los datos mediante esquemas lógicos independientes.

**Justificación:**

- Permite utilizar relaciones entre entidades.
- Ofrece transacciones ACID.
- Garantiza integridad referencial dentro de cada esquema.
- Facilita el almacenamiento de usuarios, cursos, evaluaciones y calificaciones.
- Amazon RDS reduce las tareas de administración y respaldo.

**Trade-offs:**

Ventajas:
- Tecnología confiable y ampliamente utilizada.
- Soporte de transacciones.
- Compatibilidad con el modelo entidad-relación.
- Menor complejidad inicial.

Desventajas:
- Dependencia del servicio administrado de AWS.
- Los contextos comparten inicialmente infraestructura.
- Se requieren estrategias de escalabilidad ante un crecimiento considerable.

### 2.2. Persistencia de contenidos educativos

**Decisión:** Utilizar Amazon S3 para almacenar archivos educativos.

Los documentos, imágenes y recursos académicos se almacenarán en S3, mientras sus referencias y metadatos se mantendrán en PostgreSQL.

**Justificación:**

- Permite almacenar archivos de diferentes tamaños.
- Evita sobrecargar la base de datos relacional.
- Facilita la gestión y recuperación de documentos.
- Se integra con los servicios administrados de AWS.

**Trade-offs:**

Ventajas:
- Escalabilidad.
- Almacenamiento especializado.
- Integración con otros servicios AWS.

Desventajas:
- Costos asociados al almacenamiento y transferencia.
- Necesidad de administrar correctamente los permisos.

### 2.3. Motor de búsqueda vectorial

**Decisión:** Utilizar Amazon OpenSearch Serverless para el Tutor IA en el entorno de producción propuesto.

Este servicio permitirá almacenar y recuperar representaciones vectoriales de los contenidos educativos.

**Justificación:**

- Facilita la búsqueda semántica.
- Permite recuperar información relacionada con las consultas de los estudiantes.
- Complementa el funcionamiento del Tutor IA.
- Reduce la administración de infraestructura especializada.

**Trade-offs:**

Ventajas:
- Servicio administrado.
- Soporte para búsquedas vectoriales.
- Integración con el ecosistema AWS.

Desventajas:
- Costos adicionales de operación.
- Dependencia de AWS.
- Mayor complejidad respecto de alternativas locales.

**Consideración:** El C4 inicial utiliza ChromaDB. La elección de OpenSearch Serverless corresponde al despliegue cloud propuesto y requiere actualizar el C4 L2 para evitar inconsistencias.

### 2.4. Broker de eventos

**Decisión:** Utilizar Amazon EventBridge junto con Amazon SQS.

EventBridge funcionará como bus de distribución de eventos y SQS permitirá mantener colas independientes para los consumidores que necesiten procesamiento asíncrono.

**Justificación:**

- Facilita la comunicación entre Bounded Contexts.
- Reduce el acoplamiento entre productores y consumidores.
- Permite incorporar nuevos consumidores sin modificar al productor.
- Facilita los reintentos y el procesamiento de mensajes pendientes.
- Se integra con la infraestructura AWS previamente seleccionada.

**Trade-offs:**

Ventajas:
- Comunicación desacoplada.
- Servicios administrados.
- Escalabilidad.
- Procesamiento asíncrono.

Desventajas:
- Mayor complejidad para depuración.
- Consistencia eventual entre contextos.
- Posibilidad de mensajes duplicados.
- Costos adicionales de infraestructura.

---

## 3. Selección de patrones arquitectónicos

### 3.1. Transactional Outbox

**Decisión: Aplicar Transactional Outbox en operaciones que generan eventos de integración.**

Este patrón permite registrar cambios de negocio y eventos pendientes dentro de una misma transacción de base de datos.

**Ejemplo en AulaViva:**

Cuando un estudiante termina una evaluación:

1. El sistema registra la entrega en PostgreSQL.
2. En la misma transacción se guarda un evento pendiente en la tabla Outbox.
3. Un publicador consulta los eventos pendientes.
4. El evento se envía a Amazon EventBridge.
5. EventBridge lo distribuye a los consumidores mediante las reglas y colas configuradas.
6. El evento se marca como publicado después de confirmar su entrega al bus.

**Justificación:**

Evita que una operación quede correctamente almacenada en la base de datos sin dejar registro del evento que debe publicarse.

**Trade-offs:**

Ventajas:
- Mantiene consistencia entre datos de negocio y registro de eventos.
- Permite reintentar publicaciones fallidas.
- Reduce el riesgo de perder eventos.

Desventajas:
- Requiere una tabla adicional.
- Necesita implementar un proceso publicador.
- Puede generar publicaciones duplicadas durante los reintentos.

Los consumidores deberán implementar idempotencia utilizando `event_id` para evitar efectos duplicados.

### 3.2. CQRS — Command Query Responsibility Segregation

**Decisión: No implementar CQRS completo en la etapa inicial. Evaluar su aplicación parcial para consultas de seguimiento y reportes.**

CQRS permite separar los modelos responsables de modificar información de aquellos utilizados para consultarla.

En AulaViva, las operaciones de creación y entrega de evaluaciones pueden compartir inicialmente el mismo modelo de persistencia.

Sin embargo, los reportes de rendimiento académico podrían beneficiarse de modelos de lectura especializados.

**Ejemplo:**

- Escritura: registrar la calificación de una evaluación.
- Lectura: consultar el promedio de un curso o la evolución académica de un estudiante.

**Justificación:**

La implementación completa de CQRS aumentaría la complejidad del sistema sin aportar inicialmente beneficios proporcionales.

Se propone comenzar con consultas convencionales sobre PostgreSQL y considerar proyecciones de lectura si el volumen o la complejidad de los reportes lo requiere.

**Trade-offs:**

Ventajas:
- Posibilidad de optimizar consultas académicas.
- Separación de responsabilidades cuando sea necesaria.
- Escalabilidad futura de reportes.

Desventajas:
- Mayor complejidad de mantenimiento.
- Posible duplicación de información.
- Consistencia eventual si se utilizan proyecciones asíncronas.

### 3.3. Saga

**Decisión: No aplicar Saga inicialmente.**

Saga permite coordinar procesos de negocio que involucran múltiples transacciones independientes, mediante pasos y acciones de compensación.

En el alcance actual de AulaViva, los procesos de evaluación pueden resolverse principalmente dentro de un contexto y mediante transacciones locales.

**Ejemplo de posible uso futuro:**

Si la matrícula de un estudiante requiriera coordinar servicios independientes de gestión académica, asignación de contenidos y habilitación de evaluaciones, podría considerarse una Saga.

**Justificación:**

Implementar Saga desde el inicio introduciría complejidad adicional sin una necesidad suficientemente justificada.

**Trade-offs:**

Ventajas de una implementación futura:
- Coordinación de procesos distribuidos.
- Gestión de fallos parciales.
- Posibilidad de definir acciones compensatorias.

Desventajas:
- Mayor complejidad de implementación.
- Necesidad de controlar estados intermedios.
- Dificultad para definir compensaciones correctas.

Se evaluará nuevamente si AulaViva incorpora procesos distribuidos que no puedan resolverse mediante transacciones locales.

---

## 4. Alternativas tecnológicas consideradas

| Componente | Alternativa | Motivo de descarte inicial |
|---|---|---|
| Base de datos | MongoDB | Se prioriza el modelo relacional y las transacciones ACID. |
| Base vectorial | ChromaDB autogestionado | OpenSearch Serverless se ajusta mejor al despliegue AWS propuesto. |
| Broker | Apache Kafka | Mayor complejidad para las necesidades iniciales del proyecto. |
| Broker | RabbitMQ autogestionado | Mayor carga de administración frente a EventBridge y SQS. |
| Comunicación | Exclusivamente REST | Generaría mayor acoplamiento para notificaciones y procesos asíncronos. |

## 5. Seguridad y consistencia

Se establecen las siguientes consideraciones:

- Cada evento tendrá un identificador único `event_id`.
- Los eventos incluirán versión y fecha de ocurrencia.
- Se utilizará `tenant_id` para identificar el establecimiento correspondiente.
- Los consumidores deberán respetar el aislamiento multi-tenant.
- No se incluirá información personal innecesaria en los mensajes.
- Se implementará idempotencia para controlar eventos duplicados.
- Se contemplarán reintentos y colas de mensajes fallidos.
- La publicación de eventos podrá producir consistencia eventual entre contextos.
- Los fallos deberán registrarse para facilitar seguimiento y diagnóstico.

## 6. Consecuencias de la decisión

### Consecuencias positivas

- Arquitectura coherente con los ADR anteriores.
- Separación lógica de los Bounded Contexts.
- Almacenamiento adecuado según el tipo de información.
- Menor acoplamiento entre módulos.
- Mayor confiabilidad en la publicación de eventos mediante Outbox.
- Posibilidad de evolucionar hacia CQRS o Saga cuando exista una necesidad real.
- Integración con la infraestructura administrada de AWS.

### Consecuencias negativas

- Mayor complejidad frente a una arquitectura exclusivamente síncrona.
- Costos adicionales asociados a servicios cloud.
- Necesidad de administrar eventos pendientes y fallidos.
- Consistencia eventual entre algunos procesos.
- Dependencia de tecnologías AWS.
- Necesidad de sincronizar la documentación C4 con las decisiones actuales.

## 7. Decisión final

Se propone mantener PostgreSQL mediante Amazon RDS como motor relacional principal, utilizar Amazon S3 para archivos y Amazon OpenSearch Serverless para búsqueda vectorial.

La comunicación asíncrona utilizará Amazon EventBridge y Amazon SQS.

Respecto de los patrones arquitectónicos:

- **Transactional Outbox:** seleccionado para operaciones que publican eventos.
- **CQRS:** no se implementará completamente en la etapa inicial; se evaluará para reportes.
- **Saga:** no se implementará inicialmente debido al alcance actual de los procesos.

Estas decisiones buscan equilibrar consistencia, escalabilidad, facilidad de mantenimiento, costos y complejidad técnica.

## 8. Documentación relacionada

- [ADR 0002 — Estilo Arquitectónico](0002-estilo-arquitectonico.md)
- [Bounded Contexts](../data/bounded-contexts.md)
- [Catálogo de Eventos](../data/event-catalog.md)
- [Modelo DER en DBML](../data/der.dbml)
- [Servicios Cloud Administrados](../arch/managed-services.md)
- [C4 Nivel 2](../c4/l2-container.puml)
