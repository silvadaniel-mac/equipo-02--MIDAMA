# Documentación de AulaViva

AulaViva es una plataforma educativa SaaS multi-tenant del equipo MIDAMA. Este índice reúne la documentación por tema y por sesión.

## Recorrido por sesión

| Sesión | Avances y acceso | Estado documentado |
| --- | --- | --- |
| Inicio | [Charter y equipo](../CHARTER.md), [impact map](impact-map.md), [backlog](backlog.md) | Definición del proyecto |
| S03–S04 | [C4](c4/README.md), [ADRs](ADR/README.md), [12 factores](12-factor-checklist.md), [servicios cloud](arch/managed-services.md) | Arquitectura propuesta y decisiones registradas |
| S05 | [Contrato y requisitos](api/README.md), [OpenAPI](../api/openapi.yaml), [cliente TypeScript](../packages/api-client/README.md) | Contrato, ejemplos y validación automatizada |
| S06 | [Modelo de datos y eventos](data/README.md) | Diseño de contextos, DER y eventos; no equivale a persistencia implementada |
| S07 | [Contenedores, Kubernetes e IaC](sesiones/s07-contenedores-kubernetes-iac.md) | Implementación del laboratorio y matriz de evidencias |

## Consulta por tema

- [Decisiones de arquitectura](ADR/README.md)
- [Diagramas C4 actuales e históricos](c4/README.md)
- [Datos y eventos](data/README.md)
- [API y política de versionado](api/README.md)
- [Escenarios de aceptación](scenarios/)
- [Guía de despliegue S07](../k8s/README.md)
- [Terraform y estado remoto](../terraform/README.md)

El contrato de negocio, la implementación del laboratorio y la arquitectura futura tienen alcances distintos. La base ejecutable S07 expone salud y disponibilidad; los endpoints académicos del contrato S05 siguen pendientes.
