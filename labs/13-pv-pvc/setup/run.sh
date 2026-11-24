#!/usr/bin/env bash
# Lab 13 준비: 모든 노드에 /mnt/data 생성, local-storage StorageClass(lab 10 풀이) 적용
set -euo pipefail
for n in master worker-1 worker-2; do node_exec "$n" "mkdir -p /mnt/data"; done
kubectl apply -f "$LAB_DIR/../10-storageclass/solution/solution.yaml"
log "준비 완료: data-pv PV와 data-pvc PVC를 만드세요"
