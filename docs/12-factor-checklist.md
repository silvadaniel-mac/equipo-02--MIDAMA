# Checklist 12-Factor App - AulaViva

## Auditoría Cloud Native

| Factor | Estado | Acción | Responsable |
|---|---|---|---|
| 1. Codebase | Cumple | Mantener una única base de código versionada en GitHub con control de cambios. | Equipo Desarrollo |
| 2. Dependencies | Cumple | Gestionar dependencias mediante archivos declarativos (package.json, requirements.txt). | Backend |
| 3. Config | Parcial | Separar configuraciones mediante variables de entorno (.env) para cada ambiente. | Backend / Cloud |
| 4. Backing Services | Cumple | Utilizar servicios externos configurables como PostgreSQL, almacenamiento y APIs mediante URLs. | Arquitectura |
| 5. Build, Release, Run | Parcial | Implementar separación entre construcción, liberación y ejecución mediante pipeline CI/CD. | DevOps |
| 6. Processes | Cumple | Mantener servicios stateless evitando almacenar sesiones en memoria local. | Backend |
| 7. Port Binding | Cumple | Exponer la aplicación mediante puertos definidos por el servicio cloud. | Backend |
| 8. Concurrency | Parcial | Permitir escalamiento horizontal del backend según demanda. | Cloud |
| 9. Disposability | Cumple | Configurar inicio rápido y cierre controlado de servicios. | Cloud |
| 10. Dev/Prod Parity | Parcial | Mantener ambientes de desarrollo y producción con configuraciones similares. | Equipo Desarrollo |
| 11. Logs | Cumple | Gestionar logs como streams para monitoreo centralizado. | Cloud |
| 12. Admin Processes | Cumple | Ejecutar tareas administrativas mediante procesos controlados y automatizados. | Equipo Desarrollo |
