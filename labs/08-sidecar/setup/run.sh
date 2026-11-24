#!/usr/bin/env bash
# Lab 08 준비: 미리 만들 리소스 없음 (이전 log-pod가 남아 있으면 지움)
set -euo pipefail
kubectl delete pod log-pod --ignore-not-found
log "준비 완료: default namespace에 log-pod를 만드세요"
