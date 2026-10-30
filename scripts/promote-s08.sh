#!/usr/bin/env bash
# En checkout del repo GitOps. Solo modifica dev y abre un PR, nunca mergea.
set -euo pipefail
: "${GH_TOKEN:?token temporal de GitHub App requerido}"
: "${GITOPS_REPOSITORY:?owner/repo requerido}"
: "${IMAGE_DIGEST:?digest requerido}"
: "${APP_SHA:?SHA requerido}"
[[ "$APP_SHA" =~ ^[0-9a-f]{40}$ ]] || exit 2
[[ "$IMAGE_DIGEST" =~ ^sha256:[0-9a-f]{64}$ ]] || exit 2
branch="promote/$APP_SHA"
# Un rerun no duplica PRs ni reescribe una rama existente.
if gh pr list --repo "$GITOPS_REPOSITORY" --head "$branch" --state all --json number --jq '.[].number' | grep -q .; then
  echo "La promoción de $APP_SHA ya tiene PR."; exit 0
fi
git switch -c "$branch"
python3 - <<'PYTHON'
import os
from pathlib import Path
p=Path('overlays/dev/kustomization.yaml')
s=p.read_text(); lines=s.splitlines()
lines=[line for line in lines if not line.strip().startswith(('newTag:', 'digest:'))]
lines.append('    digest: '+os.environ['IMAGE_DIGEST'])
p.write_text('\n'.join(lines)+'\n')
PYTHON
kubectl kustomize overlays/dev >/dev/null
git config user.name 'aulaviva-release[bot]'
git config user.email 'aulaviva-release@users.noreply.github.com'
git add overlays/dev/kustomization.yaml
git commit -m "release(dev): AulaViva $APP_SHA"
git push origin "$branch"
printf 'Promoción de AulaViva.\n\nCommit app: %s\nImagen inmutable: %s\n\nArgo CD reconciliará dev al fusionar este PR. Producción requiere otro PR con dos revisores.\n' "$APP_SHA" "$IMAGE_DIGEST" > /tmp/promotion-body.md
gh pr create --repo "$GITOPS_REPOSITORY" --base main --head "$branch" --title "release(dev): AulaViva $APP_SHA" --body-file /tmp/promotion-body.md
