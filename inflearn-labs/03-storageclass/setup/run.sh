#!/usr/bin/env bash
set -euo pipefail
# 준비: 없음 (StorageClass를 처음부터 만드는 실습). 이전 실습의 local-storage가 남아 있으면 지운다

kubectl delete storageclass local-storage --ignore-not-found
log "준비할 리소스 없음 — 바로 문제를 풀면 된다"
