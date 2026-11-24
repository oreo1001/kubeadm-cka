#!/usr/bin/env bash
set -euo pipefail
# 준비: manual StorageClass와 Released 상태가 될 old-data-pv(없는 PVC를 claimRef로 가리킴) 생성

kubectl apply -f setup.yaml
# PV 컨트롤러가 claimRef의 PVC가 없음을 보고 Released로 바꿀 때까지 잠깐 기다린다
for _ in $(seq 1 30); do
  phase="$(kubectl get pv old-data-pv -o jsonpath='{.status.phase}')"
  [ "$phase" = "Released" ] && break
  sleep 2
done
kubectl get pv old-data-pv
