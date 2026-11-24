#!/usr/bin/env bash
# Lab 01 준비: 미리 만들 리소스 없음 (이전 풀이가 남아 있으면 지워 처음 상태로)
set -euo pipefail
kubectl delete -f "$LAB_DIR/solution/solution.yaml" --ignore-not-found
log "준비 완료: high-priority PriorityClass와 critical-nginx Pod를 만드세요"
