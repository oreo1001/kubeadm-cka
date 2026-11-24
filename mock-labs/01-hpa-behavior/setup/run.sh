#!/usr/bin/env bash
# Mock 01 준비: autoscale namespace에 api Deployment 배포 (metrics-server는 env-up 때 이미 설치됨)
set -euo pipefail
kubectl apply -f setup.yaml
kubectl -n autoscale rollout status deploy/api --timeout=180s
kubectl -n kube-system rollout status deploy/metrics-server --timeout=180s
log "준비 완료: api-hpa를 만드세요 (kubectl top pod -n autoscale 값은 1~2분 뒤 나옴)"
