#!/bin/bash
# Mock 04 고장 주입 — master 노드에서 root로 실행
set -euo pipefail
MAN=/etc/kubernetes/manifests
BK=/root/cka-backup/mock04
mkdir -p "$BK"
cp -n "$MAN/kube-scheduler.yaml" "$MAN/kube-controller-manager.yaml" "$BK/"

# 1) scheduler 실행 명령 오타
sed -i 's/^\(\s*- \)kube-scheduler$/\1kube-schedulerr/' "$MAN/kube-scheduler.yaml"
# 2) controller-manager kubeconfig 경로 오타 (--authentication-kubeconfig 등은 건드리지 않음)
sed -i 's#--kubeconfig=/etc/kubernetes/controller-manager.conf#--kubeconfig=/etc/kubernetes/controller-manager.config#' \
  "$MAN/kube-controller-manager.yaml"
echo "고장 주입 완료. 원본: $BK"
