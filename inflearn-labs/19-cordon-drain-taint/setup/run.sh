#!/usr/bin/env bash
set -euo pipefail
# 준비: worker-2(cka-worker2)에 고정된 drain-test Deployment(3개) 배포

kubectl apply -f setup.yaml
kubectl rollout status deployment/drain-test --timeout=180s
kubectl get pods -o wide -l app=drain-test
