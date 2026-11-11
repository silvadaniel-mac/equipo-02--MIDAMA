#!/usr/bin/env bash
set -euo pipefail
: "${IMAGE:?}" "${DIGEST:?}" "${UNSIGNED_DIGEST:?}" "${REGISTRY_TOKEN:?}"
mkdir -p artifacts
kubectl create namespace equipo-02
kubectl label namespace equipo-02 pod-security.kubernetes.io/enforce=restricted
kubectl create namespace kyverno
# El token solo vive en Secrets del clúster efímero. Nunca se exporta en evidencias.
for namespace in equipo-02 kyverno; do
  kubectl create secret docker-registry ghcr-pull --namespace "$namespace" --docker-server=ghcr.io --docker-username="$GITHUB_ACTOR" --docker-password="$REGISTRY_TOKEN" >/dev/null
done
helm repo add kyverno https://kyverno.github.io/kyverno/
helm repo update kyverno
helm upgrade --install kyverno kyverno/kyverno --version 3.9.2 -n kyverno --set admissionController.replicas=1 --set backgroundController.replicas=1 --set cleanupController.enabled=false --set reportsController.enabled=false --wait --timeout 5m
kubectl rollout status -n kyverno deployment/kyverno-admission-controller --timeout=180s
# Solo en kind de la rama de trabajo se usa la identidad exacta de esa rama.
# El archivo versionado admite exclusivamente main. No se usa un comodín de confianza.
sed "s|@refs/heads/main|@$GITHUB_REF|g" k8s/policies/require-signature.yaml > artifacts/require-signature-rendered.yaml
kubectl apply -f artifacts/require-signature-rendered.yaml
kubectl wait --for=condition=Ready clusterpolicy/require-image-signature --timeout=120s
sleep 10
sed "s|IMAGE_BY_DIGEST|$IMAGE@$DIGEST|" k8s/staging/deployment.yaml > artifacts/staging-deployment.yaml
kubectl apply -f artifacts/staging-deployment.yaml
kubectl rollout status -n equipo-02 deployment/aulaviva-api --timeout=240s
printf 'ADMISION POSITIVA OK: %s@%s\n' "$IMAGE" "$DIGEST" | tee artifacts/admission-positive.txt
python3 - <<'PY'
import json, os
pod={"apiVersion":"v1","kind":"Pod","metadata":{"name":"unsigned-negative-control","namespace":"equipo-02"},"spec":{"automountServiceAccountToken":False,"securityContext":{"runAsNonRoot":True,"runAsUser":65532,"seccompProfile":{"type":"RuntimeDefault"}},"containers":[{"name":"api","image":os.environ['IMAGE']+'@'+os.environ['UNSIGNED_DIGEST'],"resources":{"requests":{"cpu":"50m","memory":"32Mi"},"limits":{"cpu":"100m","memory":"64Mi"}},"securityContext":{"allowPrivilegeEscalation":False,"readOnlyRootFilesystem":True,"capabilities":{"drop":["ALL"]}}}]}}
open('artifacts/unsigned-pod.json','w').write(json.dumps(pod))
PY
set +e
kubectl apply -f artifacts/unsigned-pod.json > artifacts/admission-negative.txt 2>&1
status=$?
set -e
test "$status" -ne 0
grep -q 'verify-signature-and-slsa' artifacts/admission-negative.txt
if kubectl get pod unsigned-negative-control -n equipo-02 >/dev/null 2>&1; then
  echo 'ERROR: el Pod sin firma llegó a crearse'; exit 1
fi
cat artifacts/admission-negative.txt
echo 'ADMISION NEGATIVA OK: Kyverno rechazó el digest sin firma.'
kubectl port-forward -n equipo-02 service/aulaviva-api 18080:80 > artifacts/staging-port-forward.txt 2>&1 &
curl --retry 20 --retry-all-errors --retry-delay 1 --fail http://127.0.0.1:18080/readyz | tee artifacts/staging-ready.json
curl --fail http://127.0.0.1:18080/ | tee artifacts/staging-release.json
