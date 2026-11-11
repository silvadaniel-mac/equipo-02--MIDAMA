#!/usr/bin/env bash
set -euo pipefail
mkdir -p artifacts
set +e
cosign verify --certificate-identity "https://github.com/$GITHUB_WORKFLOW_REF" --certificate-oidc-issuer https://token.actions.githubusercontent.com "$IMAGE@$UNSIGNED_DIGEST" > artifacts/cosign-negative-unsigned.txt 2>&1
unsigned_status=$?
cosign verify --certificate-identity https://github.com/untrusted/other/.github/workflows/build.yml@refs/heads/main --certificate-oidc-issuer https://token.actions.githubusercontent.com "$IMAGE@$DIGEST" > artifacts/cosign-negative-identity.txt 2>&1
identity_status=$?
set -e
test "$unsigned_status" -ne 0
test "$identity_status" -ne 0
grep -Eqi 'no signatures|no matching signatures' artifacts/cosign-negative-unsigned.txt
grep -Eqi 'identity|subject|certificate' artifacts/cosign-negative-identity.txt
printf 'CONTROL NEGATIVO OK: sin firma=%s, identidad ajena=%s\n' "$unsigned_status" "$identity_status" | tee artifacts/signature-negative-summary.txt
