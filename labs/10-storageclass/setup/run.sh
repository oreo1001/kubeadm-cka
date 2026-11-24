#!/usr/bin/env bash
# Lab 10 준비: 미리 만들 리소스 없음 (local-storage StorageClass가 남아 있으면 지움)
set -euo pipefail
kubectl delete storageclass local-storage --ignore-not-found
log "준비 완료: local-storage StorageClass를 만드세요"
