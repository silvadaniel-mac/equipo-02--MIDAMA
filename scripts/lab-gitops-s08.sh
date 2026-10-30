#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${APP_SHA:?SHA requerido}"
: "${SOURCE_REF:?rama requerida}"
[[ "$(kubectl config current-context)" == kind-aulaviva-s08 ]] || exit 2
mkdir -p artifacts
kind load docker-image "aulaviva-api:$APP_SHA" --name aulaviva-s08
kubectl create namespace argocd
kubectl apply --server-side --force-conflicts -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.1.9/manifests/install.yaml
kubectl rollout status deployment/argocd-repo-server -n argocd --timeout=300s
kubectl rollout status deployment/argocd-server -n argocd --timeout=300s
kubectl rollout status statefulset/argocd-application-controller -n argocd --timeout=300s
# Laboratorio temporal: el bundle vive provisionalmente en app/gitops.
# La configuración definitiva exportada apunta al repo separado.
cat <<EOF | kubectl apply -f -
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: aulaviva-dev
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/$GITHUB_REPOSITORY.git
    targetRevision: $SOURCE_REF
    path: gitops/overlays/dev
    kustomize:
      images:
        - ghcr.io/silvadaniel-mac/aulaviva-api=aulaviva-api:$APP_SHA
  destination:
    server: https://kubernetes.default.svc
    namespace: aulaviva-dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
EOF
for attempt in $(seq 1 90); do
  sync=$(kubectl get application aulaviva-dev -n argocd -o jsonpath='{.status.sync.status}')
  health=$(kubectl get application aulaviva-dev -n argocd -o jsonpath='{.status.health.status}')
  printf 'sync=%s health=%s\n' "$sync" "$health" | tee -a artifacts/argocd-wait.txt
  if [[ "$sync" == Synced && "$health" == Healthy ]]; then break; fi
  sleep 5
done
[[ "$sync" == Synced && "$health" == Healthy ]]
kubectl get application aulaviva-dev -n argocd -o json > artifacts/argocd-synced-healthy.json
kubectl rollout status deployment/aulaviva-api -n aulaviva-dev --timeout=120s
# Drift: modificar a 2 réplicas fuera de Git y comprobar que selfHeal vuelve a 1.
kubectl scale deployment aulaviva-api -n aulaviva-dev --replicas=2
for attempt in $(seq 1 60); do
  replicas=$(kubectl get deployment aulaviva-api -n aulaviva-dev -o jsonpath='{.spec.replicas}')
  if [[ "$replicas" == 1 ]]; then break; fi
  sleep 5
done
[[ "$replicas" == 1 ]]
echo 'selfHeal corrigió drift de 2 a 1 réplica.' | tee artifacts/self-heal.txt
kubectl port-forward -n aulaviva-dev svc/aulaviva-api 8080:80 >/tmp/api-forward.log 2>&1 &
forward_pid=$!
trap 'kill "$forward_pid" || true' EXIT
curl --retry 20 --retry-all-errors --retry-connrefused --retry-delay 1 --fail http://localhost:8080/ | tee artifacts/http-release.json
APP_SHA="$APP_SHA" python3 - <<'PY'
import json, os
from pathlib import Path
body=json.loads(Path('artifacts/http-release.json').read_text())
assert body['release']==os.environ['APP_SHA'], body
PY
