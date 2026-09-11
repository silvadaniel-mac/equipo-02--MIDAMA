# Checklist 12-Factor App - AulaViva

## Auditoría Cloud Native aplicada a AulaViva

| Factor | Estado | Acción | Responsable |
|---|---|---|---|
| 1. Codebase | Cumple | Mantener frontend, backend y servicios IA versionados en GitHub mediante repositorio controlado. | Equipo Desarrollo |
| 2. Dependencies | Cumple | Gestionar dependencias con archivos declarativos como package.json y requirements.txt. | Backend |
| 3. Config | Parcial | Implementar variables de entorno para credenciales AWS, base de datos, APIs externas y configuración por ambiente. | Backend / Cloud |
| 4. Backing Services | Cumple | Utilizar servicios externos como Amazon RDS, Amazon S3, Amazon SES y OpenSearch mediante configuraciones externas. | Arquitectura |
| 5. Build, Release, Run | Parcial | Crear pipeline CI/CD para separar construcción de imágenes, despliegue y ejecución en ECS Fargate. | DevOps |
| 6. Processes | Cumple | Mantener Backend API y Tutor IA como servicios stateless para permitir escalamiento horizontal. | Backend |
| 7. Port Binding | Cumple | Exponer la API mediante puertos definidos dentro de los contenedores desplegados en ECS. | Backend |
| 8. Concurrency | Parcial | Configurar escalamiento automático de tareas ECS según carga de usuarios y solicitudes IA. | Cloud |
| 9. Disposability | Cumple | Configurar contenedores con inicio rápido y cierre controlado para reemplazos automáticos. | Cloud |
| 10. Dev/Prod Parity | Parcial | Mantener ambientes similares utilizando contenedores y configuraciones equivalentes. | Equipo Desarrollo |
| 11. Logs | Parcial | Centralizar logs del Backend API y Tutor IA mediante servicios de monitoreo cloud como Amazon CloudWatch. | Cloud |
| 12. Admin Processes | Cumple | Ejecutar migraciones de base de datos y tareas administrativas mediante procesos controlados. | Backend |
