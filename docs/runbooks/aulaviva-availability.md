# Runbook inicial: API AulaViva no disponible

Responsable: integrante de MIDAMA a cargo del despliegue. Alcance: base de despliegue del taller, sin datos reales de alumnos.

## Señal y evaluación

Un fallo en `/readyz`, un rollout sin Pods disponibles o un gate de firma/DAST fallido requiere revisar el release antes de promover. El laboratorio no tiene aún monitoreo continuo ni SLO histórico.

```bash
kubectl get deployment,pods,service -n equipo-02
kubectl rollout status deployment/aulaviva-api -n equipo-02 --timeout=60s
kubectl logs deployment/aulaviva-api -n equipo-02 --tail=100
kubectl describe pod -n equipo-02 -l app=aulaviva-api
kubectl port-forward -n equipo-02 service/aulaviva-api 18080:80
# En otra terminal
curl --fail http://127.0.0.1:18080/healthz
curl --fail http://127.0.0.1:18080/readyz
curl --fail http://127.0.0.1:18080/
```

## Diagnóstico

| Síntoma | Comprobación | Acción |
| --- | --- | --- |
| Rechazo Kyverno | Subject, issuer, digest y attestation | Reconstruir desde workflow confiable, nunca desactivar la policy |
| ImagePullBackOff | Acceso de lectura del Secret GHCR y digest existente | Renovar el token del laboratorio, sin publicarlo en logs |
| Healthz 200 y readyz 503 | Estado de cierre del proceso | Esperar drenaje o corregir disponibilidad antes de servir tráfico |
| Alerta Falco High | Regla, Pod, comando, usuario y destino del evento | Registrar incidente, validar si es simulacro y aislar si corresponde |
| ZAP Medium+ | Reporte y SHA del contenedor | Corregir el hallazgo y repetir todos los gates |

## Recuperación y cierre

Restaurar solo un digest previamente firmado y verificado, comprobar nuevamente `/readyz` y conservar run, SHA y digest. No usar tags mutables como evidencia del release. Registrar causa, duración y mejora preventiva en un PR.

Lectura para S11: [Google SRE Workbook, Alerting on SLOs](https://sre.google/workbook/alerting-on-slos/). En S11 se definirán SLIs, ventana de medición y objetivo antes de calcular error budgets.
