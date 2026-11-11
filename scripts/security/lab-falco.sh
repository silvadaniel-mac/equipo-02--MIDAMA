#!/usr/bin/env bash
set -euo pipefail
mkdir -p artifacts/incidents
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm repo update falcosecurity
helm upgrade --install falco falcosecurity/falco --version 9.2.2 --namespace falco --create-namespace -f falco/values.yaml --set-file 'customRules.rules-custom\.yaml=falco/rules-custom.yaml' --wait --timeout 6m
kubectl rollout status daemonset/falco -n falco --timeout=180s
kubectl exec -n falco daemonset/falco -c falco -- falco --validate /etc/falco/falco_rules.yaml --validate /etc/falco/rules.d/rules-custom.yaml | tee artifacts/falco-rules-validation.txt
kubectl create namespace equipo-02-falco-test
kubectl label namespace equipo-02-falco-test pod-security.kubernetes.io/enforce=restricted
kubectl apply -f k8s/lab/falco-canary.yaml
kubectl wait -n equipo-02-falco-test --for=condition=Ready pod/aulaviva-falco-canary --timeout=120s
# Permitir que el plugin de containerd enriquezca la metadata del Pod.
sleep 8
for attempt in $(seq 1 6); do
  kubectl exec -n equipo-02-falco-test aulaviva-falco-canary -- sh -c 'echo s10-shell-drill; echo synthetic > /etc/aulaviva-drill; nc -w 2 1.1.1.1 443 < /dev/null || true'
  sleep 5
  kubectl logs -n falco -l app.kubernetes.io/name=falco -c falco --tail=-1 > artifacts/falco-runtime.jsonl
  if python3 scripts/security/falco-incidents.py artifacts/falco-runtime.jsonl artifacts/incidents; then
    break
  fi
done
python3 scripts/security/falco-incidents.py artifacts/falco-runtime.jsonl artifacts/incidents
kubectl get pods -n falco -o wide > artifacts/falco-pods.txt
kubectl delete namespace equipo-02-falco-test --wait=false
echo 'FALCO OK: tres reglas cargadas, tres tipos de alerta High y sus incidentes de simulacro.'
