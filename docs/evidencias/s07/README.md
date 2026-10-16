# Evidencias S07

## Validaciones realizadas en la preparación

- Pruebas HTTP del servicio: **4 aprobadas** (`npm run platform:test`).
- Contrato OpenAPI: Spectral sin advertencias/errores, generación de tipos y TypeScript correctos, **3 pruebas aprobadas** (`npm run api:check`).
- Ejemplos S05 contra Prism: **4 aprobados** (listado y creación de contenidos, calificación y consulta tutor simulados).
- YAML de Kubernetes y workflows: parseo sin errores.
- Sintaxis Bash y código del Job de carga: correctos.
- `actionlint` 1.7.7: sin errores en ambos workflows.
- `terraform fmt -check -recursive`: correcto.
- Inicialización Terraform: provider Kubernetes 2.38.0 descargado y lockfiles generados para ambas raíces.

## Restricciones del entorno de preparación

No hay Docker/kind/kubectl instalados para ejecutar el clúster. La validación de Terraform no pudo iniciar el provider porque el entorno rechaza el socket Unix de comunicación (`socket: operation not permitted`). Por eso no se presenta `terraform validate`, el build, el tamaño de imagen ni HPA como aprobados localmente.

El workflow `Plataforma S07` prepara un runner Ubuntu con esas herramientas. Hasta que se publique la rama y termine esa ejecución, sus resultados permanecen **pendientes**.

La publicación se realiza en la rama `feature/s07-k8s-iac`. Los resultados del workflow se incorporan después de su ejecución real.

## Evidencias por incorporar

1. Enlace al PR y a la ejecución real de Actions.
2. Artefactos del laboratorio: build/usuario/tamaño, plan sin drift, HTTP, métricas y HPA antes/durante/después.
3. Captura real de `kubectl get all -n equipo-02`, incluida también en el README principal.
4. Imagen GHCR real, digest y prueba de pull.
5. Configuración y prueba del backend remoto S3 (cifrado y lock).
6. Revisión por pares.

No se incluyen capturas fabricadas, digests ficticios ni notas de evaluación anticipadas.
