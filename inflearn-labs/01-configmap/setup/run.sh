#!/usr/bin/env bash
set -euo pipefail
# 준비: app-config ConfigMap(APP_COLOR=blue)과 이를 envFrom으로 쓰는 web-app Deployment 배포

kubectl apply -f setup.yaml
kubectl rollout status deployment/web-app --timeout=180s
