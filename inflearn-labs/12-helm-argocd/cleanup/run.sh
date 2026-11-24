#!/usr/bin/env bash
set -euo pipefail
# 정리: argocd Helm 릴리스와 argocd namespace 삭제 (helm 바이너리·ArgoCD CRD는 둔다)

export PATH="$HOME/.local/bin:$PATH"
if command -v helm >/dev/null 2>&1 && helm status argocd -n argocd >/dev/null 2>&1; then
  helm uninstall argocd -n argocd
fi
kubectl delete namespace argocd --ignore-not-found
