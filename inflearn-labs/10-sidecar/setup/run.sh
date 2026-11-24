#!/usr/bin/env bash
set -euo pipefail
# 준비: 없음 (Pod를 처음부터 만드는 실습). 이전에 남은 app-with-sidecar가 있으면 지운다

kubectl delete pod app-with-sidecar --ignore-not-found
log "준비할 리소스 없음 — 바로 문제를 풀면 된다"
