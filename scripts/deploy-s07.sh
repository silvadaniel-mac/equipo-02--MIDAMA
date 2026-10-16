#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
image="${1:?Uso: bash scripts/deploy-s07.sh ghcr.io/owner/image@sha256:DIGEST}"
if [[ ! "$image" =~ ^ghcr\.io/[a-z0-9._/-]+@sha256:[a-f0-9]{64}$ ]]; then
  echo 'Se requiere imagen GHCR con digest SHA-256 real (sin :latest).' >&2
  exit 1
fi
tmp_dir=$(mktemp -d)
trap 'rm -rf "$tmp_dir"' EXIT
kubectl kustomize k8s/ | sed "s|aulaviva-api:local|$image|g" > "$tmp_dir/deploy.yaml"
kubectl apply --dry-run=server -f "$tmp_dir/deploy.yaml"
kubectl apply -f "$tmp_dir/deploy.yaml"
kubectl rollout status deployment/aulaviva-api -n equipo-02 --timeout=180s
