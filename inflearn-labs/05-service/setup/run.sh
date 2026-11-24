#!/usr/bin/env bash
set -euo pipefail
# 준비: app=backend 라벨의 backend Deployment(http-echo, 8080) 배포

kubectl apply -f setup.yaml
kubectl rollout status deployment/backend --timeout=180s
