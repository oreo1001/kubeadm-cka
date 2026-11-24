#!/usr/bin/env bash
set -euo pipefail
# 정리: local-storage StorageClass 삭제

kubectl delete storageclass local-storage --ignore-not-found
