#!/usr/bin/env bash
set -euo pipefail
# 정리: data-pod, restored-pvc, old-data-pv, manual StorageClass 삭제

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
