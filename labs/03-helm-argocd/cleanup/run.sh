#!/usr/bin/env bash
# Lab 03 정리: argocd 릴리스 · namespace · Argo CRD · argo 저장소 삭제
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
if command -v helm >/dev/null 2>&1; then
  if helm status argocd -n argocd >/dev/null 2>&1; then helm uninstall argocd -n argocd; fi
  if helm repo list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx argo; then helm repo remove argo; fi
fi
kubectl delete namespace argocd --ignore-not-found
# 차트가 keep 정책으로 남겨 두는 CRD (applications.argoproj.io 등)
crds="$(kubectl get crd -o name | grep 'argoproj.io' || true)"
if [ -n "$crds" ]; then kubectl delete $crds --ignore-not-found; fi
