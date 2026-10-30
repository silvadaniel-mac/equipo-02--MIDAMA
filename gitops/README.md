# AulaViva MIDAMA: configuración GitOps S08

Este directorio es el paquete para el repositorio separado `equipo-02-gitops`. El script `scripts/bootstrap-gitops-s08.sh` del repositorio app crea ese repo y abre el PR de configuración.

- `base/`: Deployment nonroot, probes, recursos y Service.
- `overlays/dev/`: namespace aulaviva-dev y una réplica.
- `overlays/prod/`: namespace aulaviva-prod y dos réplicas.
- `argocd/`: proyecto restringido y Applications que observan main.
- `.github/workflows/validate.yml`: render de ambos ambientes.

Antes de instalar, reemplazar `newTag: bootstrap` por el digest publicado por CI. Es un marcador de inicialización, no una imagen real.

CI app abre un PR solo sobre dev. Producción requiere otro PR con el digest ya probado y dos aprobaciones activadas en protección de rama. Argo ejecuta la reconciliación pull tras merge. No almacenar kubeconfig ni tokens en este repo.

```bash
kubectl kustomize overlays/dev
kubectl kustomize overlays/prod
```

Para revertir, abrir PR con el digest previo, revisar, fusionar y esperar Synced/Healthy.
