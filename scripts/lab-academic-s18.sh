#!/usr/bin/env bash
set -euo pipefail
test -n "$IMAGE"
test -n "$DIGEST"
mkdir -p artifacts/academic
S18_SECRET=$(node -e "process.stdout.write(require('node:crypto').randomBytes(32).toString('hex'))")
echo "::add-mask::$S18_SECRET"
export S18_SECRET
kubectl create secret generic s18-lab-identity -n equipo-02 --from-literal=signing-material="$S18_SECRET" >/dev/null
sed "s|IMAGE_BY_DIGEST|$IMAGE@$DIGEST|" k8s/staging/academic.yaml > artifacts/academic/deployment.yaml
kubectl apply -f artifacts/academic/deployment.yaml
kubectl rollout status -n equipo-02 deployment/aulaviva-academic --timeout=240s
kubectl port-forward -n equipo-02 service/aulaviva-academic 18081:80 > artifacts/academic/port-forward.txt 2>&1 &
pid=$!
trap 'kill "$pid" 2>/dev/null || true; kubectl logs -n equipo-02 deployment/aulaviva-academic > artifacts/academic/logs.txt 2>&1 || true; kubectl delete secret -n equipo-02 s18-lab-identity >/dev/null 2>&1 || true' EXIT
curl --retry 20 --retry-all-errors --retry-delay 1 --fail http://127.0.0.1:18081/readyz
node services/s18/staging-check.mjs | tee artifacts/academic/flow.jsonl
kubectl get all -n equipo-02 -o wide | tee artifacts/academic/kubectl-get-all.txt
mkdir -p artifacts/academic/zap
chmod 777 artifacts/academic/zap
cp security/zap-rules.tsv artifacts/academic/zap/
cp security/zap-academic-hooks.py artifacts/academic/zap/hooks.py
docker run --rm --network host -v "$PWD/artifacts/academic/zap:/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:2.17.0 zap-baseline.py -t http://127.0.0.1:18081 -m 1 -T 5 -c zap-rules.tsv --hook /zap/wrk/hooks.py -J zap.json -r zap.html -I
python3 scripts/security/check-report.py zap artifacts/academic/zap/zap.json | tee artifacts/academic/zap/gate.txt
