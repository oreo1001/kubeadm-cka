#!/usr/bin/env bash
# Lab 13 정리: 테스트 Pod · data-pvc · data-pv · local-storage StorageClass · 노드의 /mnt/data 삭제
set -euo pipefail
kubectl delete pod pvc-test-pod --ignore-not-found
kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete pv data-pv --ignore-not-found
kubectl delete storageclass local-storage --ignore-not-found
for n in master worker-1 worker-2; do node_exec "$n" "rm -rf /mnt/data"; done
