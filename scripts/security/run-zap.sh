#!/usr/bin/env bash
set -euo pipefail
mkdir -p artifacts/zap
cp security/zap-rules.tsv security/zap-hooks.py artifacts/zap/
chmod 777 artifacts/zap
# El port-forward quedó abierto en un paso anterior del mismo runner.
curl --retry 10 --retry-all-errors --retry-delay 1 --fail http://127.0.0.1:18080/readyz
set +e
timeout 8m docker run --rm --network host -v "$PWD/artifacts/zap:/zap/wrk:rw" ghcr.io/zaproxy/zaproxy:2.17.0 zap-baseline.py -t http://127.0.0.1:18080 -m 1 -T 5 -c zap-rules.tsv --hook /zap/wrk/zap-hooks.py -J zap.json -r zap.html -w zap.md -I > artifacts/zap/baseline.log 2>&1
status=$?
set -e
cat artifacts/zap/baseline.log
test "$status" -eq 0
python3 scripts/security/check-report.py zap artifacts/zap/zap.json | tee artifacts/zap/gate.txt
# Control negativo del evaluador usando la estructura de un reporte ZAP.
python3 - <<'PY'
import json
json.dump({'site':[{'alerts':[{'name':'synthetic-medium','riskcode':'2'}]}]},open('artifacts/zap/negative-report.json','w'))
PY
set +e
python3 scripts/security/check-report.py zap artifacts/zap/negative-report.json > artifacts/zap/negative-gate.txt 2>&1
negative_status=$?
set -e
test "$negative_status" -ne 0
echo 'CONTROL NEGATIVO OK: el gate ZAP rechaza Medium aunque baseline use -I para Low/Info.' | tee -a artifacts/zap/gate.txt
