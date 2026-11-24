#!/usr/bin/env bash
# Mock 03 정리: web 릴리스 · helm-lab namespace · podinfo 저장소 · /tmp/web-values.yaml 삭제
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
if command -v helm >/dev/null 2>&1; then
  if helm status web -n helm-lab >/dev/null 2>&1; then helm uninstall web -n helm-lab; fi
  if helm repo list 2>/dev/null | awk 'NR>1 {print $1}' | grep -qx podinfo; then helm repo remove podinfo; fi
fi
kubectl delete namespace helm-lab --ignore-not-found
rm -f /tmp/web-values.yaml
