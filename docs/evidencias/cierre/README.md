# AulaViva MIDAMA — entrega final S18

Corte de aplicación/documentación validado: [76c5005](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/commit/76c500528b7a17466d4b0f9b3cbf1915dfbad1f3). GitOps: [b650388](https://github.com/silvadaniel-mac/equipo-02-gitops/commit/b6503884976431b45e7fa9bd72b9cd135f99ff41). Los cinco workflows de MIDAMA y la validación posterior de GitOps aprobaron.

## Organización por rol

| Integrante | Rol | Temas |
|---|---|---|
| Antonella Mancilla | Product Owner | Producto, propuesta de valor, roadmap y aprendizajes |
| Ian Godoy | QA Lead | Demo, calidad, contrato |
| Daniel Silva | Tech Lead | C4 L1/L2/L3, ocho ADRs |
| Allen Ramirez | DevSecOps Lead | Pipeline, cadena de suministro, GitOps y Terraform |
| Miguel Briceño | AI/Data Lead | Tutor híbrido, evaluación, guardrails y privacidad |
| Matías Riquelme | DevSecOps / Operación | Resiliencia, game day, SLO y FinOps |

Los siete bloques de la pauta S18 se cubren; los dos bloques del PO se agrupan para ordenar por integrante en la entrega escrita.

## Resultados y evidencia

| Bloque | Evidencia |
|---|---|
| API S05 | [run 45756742485](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45756742485) |
| Plataforma S07 | [run 45756742466](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45756742466), [salida real de kubectl](kubectl-s07.txt) |
| GitOps S08 | [run 45756742525](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45756742525), [PR automático #3 con dos aprobaciones](https://github.com/silvadaniel-mac/equipo-02-gitops/pull/3), [manifests posterior](https://github.com/silvadaniel-mac/equipo-02-gitops/actions/runs/45757708616) |
| Supply Chain S10 | [run 45756742493](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45756742493) |
| IA/Calidad S18 | [run 45756742436](https://github.com/silvadaniel-mac/equipo-02--MIDAMA/actions/runs/45756742436), [extracto de métricas](s18-metricas.txt) |
| AWS | [Backend S3 y bloqueo](../s07/backend-s3.md) |
| Arquitectura | [C4](../../c4/), [ADRs](../../ADR/registro-s18.md) |

Integración 9/9, cobertura instrumentada 96,57% líneas, 79,05% ramas y 87,80% funciones. Tutor: 40/40 sistema híbrido, 19/19 temáticos mediante LLM real, 1/1 literal determinista; Ragas no-LLM sobre recuperación ≈1 precisión y 1 recall. SLO propuesto 99,5%, 100/100 probes de muestra breve, RTO 9,3 ms y antigüedad de snapshot 27 ms en SQLite. FinOps: 1005→361 y 522→361 tokens; estimación ilustrativa US$283,99/mes, no factura. AWS: raíz MIDAMA init/validate y ensayo aislado S3 apply/locking, no apply Kubernetes remoto. GitOps dev promovido por digest, no producción permanente.

## Entregables y límites

Memoria Word Arial 12 justificada y PPT editable con el formato de sesión 3 fueron preparados como archivos de entrega externos; las capturas finales de AWS y GitHub se adjuntan al paquete académico. Este índice y los extractos de CI no pretenden sustituir la publicación de esos binarios. Las capturas no contienen credenciales. No se fabrica una captura de una terminal; se aporta el extracto original de CI. No se asigna una calificación ni se acredita exposición oral. Elaboración asistida por IA; revisión humana según Charter.
