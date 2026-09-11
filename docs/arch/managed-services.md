# Servicios Cloud Administrados - AulaViva

## Proveedor Cloud seleccionado

**AWS (Amazon Web Services)**

Se selecciona AWS debido a la disponibilidad de servicios administrados para aplicaciones web, bases de datos, contenedores e inteligencia artificial.


## Selección por contenedor C4 L2

| Contenedor | Servicio AWS | Justificación |
|---|---|---|
| Aplicación Web | AWS Amplify + CloudFront | Permite desplegar el frontend React/Next.js con distribución global y alta disponibilidad. |
| Backend API | Amazon ECS Fargate | Ejecuta contenedores sin administrar servidores, permitiendo escalar según demanda. |
| Base de Datos | Amazon RDS PostgreSQL | Servicio administrado que facilita respaldos, mantenimiento y disponibilidad de la base de datos. |
| Tutor IA | Amazon ECS Fargate + servicios IA | Permite ejecutar el servicio de inteligencia artificial de forma independiente y escalable. |
| Base Vectorial | Amazon OpenSearch Serverless | Permite almacenar y consultar embeddings utilizados por el sistema RAG. |
| Archivos educativos | Amazon S3 | Almacenamiento seguro y escalable para documentos y recursos educativos. |
| Servicio Email | Amazon SES | Servicio administrado para envío de correos y notificaciones académicas. |


## Criterio de selección

Se priorizaron servicios administrados para reducir la carga operacional y permitir que el equipo se enfoque en las funcionalidades principales de AulaViva.

Los servicios seleccionados permiten:

- Escalabilidad automática.
- Alta disponibilidad.
- Menor administración de infraestructura.
- Integración con arquitectura cloud-native.
