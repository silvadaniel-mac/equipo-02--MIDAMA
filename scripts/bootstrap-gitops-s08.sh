#!/usr/bin/env bash
# Requiere gh autenticado como dueño de TARGET. No crea credenciales.
set -euo pipefail
cd "$(dirname "$0")/.."
target="${1:-miguelbriceno-sys/equipo-02-gitops}"
[[ "$target" =~ ^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || exit 2
source_dir="$PWD/gitops"
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
gh auth status
gh repo create "$target" --public --description 'GitOps de AulaViva MIDAMA, sesión 08' --add-readme
gh repo clone "$target" "$work/repo"
cp -a "$source_dir/." "$work/repo/"
cd "$work/repo"
# Ajustar ambos Applications y el AppProject al destino elegido.
find argocd -name '*.yaml' -exec sed -i "s|miguelbriceno-sys/equipo-02-gitops|$target|g" {} +
git switch -c feature/s08-gitops
git add .
git commit -m 'feat(s08): base Kustomize, dev/prod y Argo CD'
git push -u origin feature/s08-gitops
gh pr create --base main --head feature/s08-gitops --title 'S08: configuración GitOps de AulaViva' --body 'PR coordinado con el repositorio app silvadaniel-mac/equipo-02--MIDAMA. Incluye base, overlays dev/prod y Applications Argo CD. Antes de sincronizar, promover el digest publicado por CI.'
