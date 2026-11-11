# ADR 0006: cadena de suministro firmada de AulaViva

- Estado: aceptado para el laboratorio S10, sujeto a los gates del workflow.
- Fecha: 11 de noviembre de 2026.
- Iniciativa: AulaViva, equipo MIDAMA.

## Contexto

La S09 agrega SAST, SCA, SBOM y búsqueda de secretos. Estos controles no prueban que el contenedor que llega a Kubernetes sea el que construyó el equipo. La S10 requiere escanear IaC y la imagen final, firmar por OIDC, distribuir provenance SLSA, comprobar admisión y observar syscalls con Falco.

El servicio actual es una base de despliegue sin persistencia. `/api/` responde 501. El DAST mide la superficie HTTP disponible y sus cabeceras. No demuestra seguridad de autorización multitenant, del tutor IA ni de flujos académicos aún sin implementar.

## Decisión

1. `.github/workflows/supply-chain-s10.yml` reutiliza los tres controles S09. Checkov analiza `terraform/` antes del build y falla ante cualquier check fallido o error de parsing. Corre sin descargas ni envío de resultados a Prisma Cloud. No usa `soft-fail`, baseline ni `skip-check`.
2. Trivy analiza la **imagen final** y bloquea HIGH/CRITICAL incluso sin parche. Se publica en GHCR solo después de ese gate. Un paquete S10 separado evita mezclar firmas con el workflow S08.
3. Cosign 2.6.1 firma por digest usando el token OIDC efímero de GitHub Actions. No se crea una clave privada persistente. Fulcio vincula la identidad al workflow y Rekor registra la firma. Esta versión conserva el formato OCI clásico que usa `verifyImages` y el tipo `slsaprovenance` de la consigna.
4. El build corre en un runner hospedado de GitHub. Se adjunta el predicate SLSA v0.2 con `cosign attest --type slsaprovenance`. Incluye repositorio, SHA, Dockerfile, materiales de BuildKit disponibles, tiempos y URL del run. Se expresa el nivel Build L2 pedido por el taller como build hospedado más provenance firmada y distribuida. No se afirma aislamiento de builder L3, certificación externa ni reproducibilidad bit a bit. Los campos de completitud reflejan la información realmente disponible.
5. `cosign verify` y `cosign verify-attestation` verifican issuer y **subject exactos**, sin `.*`, sin ignorar Rekor y sin desactivar comprobaciones de certificados. Además se compara digest, SHA, repositorio y builder en el payload firmado.
6. `k8s/policies/require-signature.yaml` aplica `Enforce` en `equipo-02`, exige digest del paquete permitido, firma del workflow S10 en `main` y provenance del repositorio/builder acordados. La regla también cubre init containers y ephemeral containers. El laboratorio de una rama sustituye el subject por esa rama **solo dentro de su clúster kind efímero**. El manifiesto versionado mantiene exclusivamente `main`.
7. ZAP baseline prueba el staging desplegado por ese digest después de verificar la firma. El gate JSON bloquea cualquier riesgo Medium/High, incluso reglas que se agreguen al scanner. `-I` evita fallar por Low/Info, que quedan documentadas. No hay `IGNORE` global ni un `continue-on-error`.
8. Falco 0.45.2, chart 9.2.2, usa modern eBPF. Tres reglas propias detectan shell, escritura de `/etc` y conexión externa inesperada. Cada alerta High de AulaViva crea un registro de incidente con responsable y acciones. Los simulacros se identifican como `drill`.

## Pruebas y alcance operativo

- Un security group SSH abierto a Internet vive solo en un directorio temporal y **nunca** recibe `terraform apply`. Checkov debe devolver 1 y detectar CKV_AWS_24.
- El control de firma usa una imagen con un **digest diferente** y sin firma. También verifica que una identidad ajena falle sobre la imagen firmada.
- En Kubernetes, la imagen firmada debe iniciar y la imagen sin firma debe recibir un rechazo del webhook `verify-signature-and-slsa`. Un error de descarga o de Pod Security no cuenta como evidencia de firma.
- La sonda de Falco usa datos sintéticos en un namespace separado, `equipo-02-falco-test`. No obtiene excepciones en `equipo-02`, no accede a datos académicos y se elimina después de la prueba.
- Staging y los Secrets temporales desaparecen con el runner. No se afirma que exista un entorno de producción permanente.

## Excepciones, permisos y retención

No se incorporan excepciones a los gates. Si aparece un hallazgo, se corrige y se repite el pipeline. Cualquier futura excepción debe identificar regla/CVE, alcance, responsable, evidencia y fecha de expiración en un PR y ADR revisados.

Los permisos `packages: write` e `id-token: write` se limitan a los jobs que publican/firman. El job del clúster tiene `packages: read`. El token del registro solo se guarda en Secrets del kind efímero y nunca en artefactos. No se necesita hacer público el paquete GHCR.

Los reportes del run se conservan 90 días en Actions. Las firmas y attestations permanecen en GHCR junto al digest. El equipo debe conservarlas mientras despliegue esa imagen. El respaldo de cinco años del caso CrediScore es una política del ejemplo FinTech, no una retención implementada por AulaViva.

La protección obligatoria de `main` requiere administración del repositorio. La configuración de archivos y los gates pueden entregarse con acceso de escritura, pero convertirlos en requisitos de merge es una gestión del dueño.

## Alternativas consideradas

| Alternativa | Decisión |
| --- | --- |
| Claves Cosign persistentes en Secrets | Se prefieren identidades OIDC efímeras y un registro de transparencia |
| Permitir cualquier workflow del repositorio | Se restringe al workflow S10 y ref exactos |
| Firma sin verificar provenance | No prueba origen ni relación con el commit |
| DAST sobre un mock sin desplegar la imagen | No cubre el binario construido y firmado |
| Falco sin ejecutar reglas | La sintaxis sola no prueba detección real |
| tfsec/Grype/Cosign policy-controller | Alternativas válidas, se eligen Checkov/Trivy/Kyverno para evitar herramientas duplicadas |

## Referencias oficiales

- [ZAP baseline](https://www.zaproxy.org/docs/docker/baseline-scan/)
- [Checkov, uso de CLI](https://www.checkov.io/2.Basics/CLI%20Command%20Reference.html)
- [Trivy, container images](https://trivy.dev/latest/docs/target/container_image/)
- [Sigstore, firma de contenedores](https://docs.sigstore.dev/cosign/signing/signing_with_containers/)
- [Sigstore, verificación](https://docs.sigstore.dev/cosign/verifying/verify/)
- [SLSA, niveles del build](https://slsa.dev/spec/v1.1/levels)
- [Kyverno, verificación Sigstore](https://kyverno.io/docs/policy-types/cluster-policy/verify-images/sigstore/)
- [Falco, reglas propias](https://falco.org/docs/concepts/rules/custom-ruleset/)
- [Falco, laboratorio kind](https://falco.org/docs/getting-started/learning-environments/)
