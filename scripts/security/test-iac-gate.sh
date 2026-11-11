#!/usr/bin/env bash
set -euo pipefail
mkdir -p artifacts
fixture=$(mktemp -d)
trap 'rm -rf "$fixture"' EXIT
cat > "$fixture/main.tf" <<'TF'
resource "aws_security_group" "negative_control" {
  name = "s10-negative-control-never-applied"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
TF
set +e
checkov -d "$fixture" --framework terraform --skip-download --skip-results-upload --download-external-modules false --output json > artifacts/checkov-negative.json
status=$?
set -e
test "$status" -eq 1
python3 - <<'PY'
import json
r=json.load(open('artifacts/checkov-negative.json'))
failed=r['results']['failed_checks']
assert any(c['check_id']=='CKV_AWS_24' for c in failed), 'No detectó SSH público'
print('CONTROL NEGATIVO OK: Checkov bloqueó SSH 0.0.0.0/0 con exit-code 1')
PY
