#!/usr/bin/env bash
# Lab 09 준비: production namespace에 backend · frontend · blocked-pod 배포
set -euo pipefail
kubectl apply -f setup.yaml
kubectl -n production wait --for=condition=Ready pod/backend pod/frontend pod/blocked-pod --timeout=180s
log "준비 완료: allow-frontend-to-backend NetworkPolicy를 만드세요"
