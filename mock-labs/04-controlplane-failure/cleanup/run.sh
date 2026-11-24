#!/usr/bin/env bash
# Mock 04 정리: cp-test 삭제, 백업해 둔 scheduler · controller-manager manifest 원복
set -euo pipefail
BK=/root/cka-backup/mock04
kubectl delete deployment cp-test --ignore-not-found
if node_exec master "ls $BK/*.yaml >/dev/null 2>&1"; then
  node_exec master "cp $BK/*.yaml /etc/kubernetes/manifests/"
  log "scheduler · controller-manager 복귀 대기"
  sleep 15
  kubectl -n kube-system wait --for=condition=Ready pod -l component=kube-scheduler --timeout=180s
  kubectl -n kube-system wait --for=condition=Ready pod -l component=kube-controller-manager --timeout=180s
fi
