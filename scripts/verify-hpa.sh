#!/usr/bin/env bash
# Ejecutar solo en el clúster kind de laboratorio.
set -euo pipefail
cd "$(dirname "$0")/.."
[[ "$(kubectl config current-context)" == "kind-aulaviva" ]] || { echo 'Contexto requerido: kind-aulaviva'; exit 1; }
mkdir -p artifacts
cleanup() {
  kubectl delete job aulaviva-load -n equipo-02 --ignore-not-found || true
  kubectl patch configmap aulaviva-config -n equipo-02 --type merge -p '{"data":{"ENABLE_LAB_LOAD":"false"}}' || true
  kubectl rollout restart deployment/aulaviva-api -n equipo-02 || true
}
trap cleanup EXIT
kubectl patch configmap aulaviva-config -n equipo-02 --type merge -p '{"data":{"ENABLE_LAB_LOAD":"true"}}'
kubectl rollout restart deployment/aulaviva-api -n equipo-02
kubectl rollout status deployment/aulaviva-api -n equipo-02 --timeout=180s
# Los pods recién creados necesitan muestras nuevas de Metrics Server.
metrics_ready=false
for attempt in $(seq 1 36); do
  if kubectl top pods -n equipo-02 > artifacts/top-before.txt; then
    metrics_ready=true
    break
  fi
  sleep 5
done
[[ "$metrics_ready" == true ]] || { echo 'Metrics Server no entrega muestras de los nuevos pods.'; exit 1; }
cat artifacts/top-before.txt
kubectl get hpa -n equipo-02 | tee artifacts/hpa-before.txt
kubectl delete job aulaviva-load -n equipo-02 --ignore-not-found
kubectl apply -f k8s/lab/load.yaml
scaled=false
for attempt in $(seq 1 36); do
  kubectl get hpa -n equipo-02 | tee -a artifacts/hpa-during.txt
  count=$(kubectl get deployment aulaviva-api -n equipo-02 -o jsonpath='{.spec.replicas}')
  if (( count > 2 )); then scaled=true; break; fi
  sleep 5
done
[[ "$scaled" == true ]] || { echo 'HPA no aumentó las réplicas bajo carga.'; exit 1; }
kubectl rollout status deployment/aulaviva-api -n equipo-02 --timeout=180s
kubectl top pods -n equipo-02 | tee artifacts/top-during.txt
kubectl get all -n equipo-02 -o wide | tee artifacts/kubectl-get-all.txt
kubectl get deployment aulaviva-api -n equipo-02 -o yaml > artifacts/deployment.yaml
# El Job debe completar y reportar cero errores HTTP.
kubectl wait --for=condition=complete job/aulaviva-load -n equipo-02 --timeout=240s
kubectl logs job/aulaviva-load -n equipo-02 | tee artifacts/load.txt
kubectl delete job aulaviva-load -n equipo-02
# Acreditar reducción tras finalizar la carga y la ventana de estabilización.
for attempt in $(seq 1 60); do
  count=$(kubectl get deployment aulaviva-api -n equipo-02 -o jsonpath='{.spec.replicas}')
  kubectl get hpa -n equipo-02 | tee -a artifacts/hpa-after.txt
  if (( count == 2 )); then echo 'HPA aumentó y volvió a minReplicas=2.' | tee artifacts/hpa-result.txt; exit 0; fi
  sleep 5
done
echo 'HPA aumentó, pero no volvió a 2 réplicas dentro del plazo.' >&2
exit 1
