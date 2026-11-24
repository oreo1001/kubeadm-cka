#!/usr/bin/env bash
# Mock 06 준비: sidecar namespace에 logger Deployment 배포
set -euo pipefail
kubectl apply -f setup.yaml
kubectl -n sidecar rollout status deploy/logger --timeout=180s
log "준비 완료: logger에 native sidecar log-tail을 추가하세요"
