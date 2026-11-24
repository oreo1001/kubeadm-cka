#!/usr/bin/env bash
# Mock 05 정리: worker-1(cka-worker)의 kubelet.conf · config.yaml을 백업본으로 되돌리고 kubelet 재시작
set -euo pipefail
BK=/root/cka-backup/mock05
if node_exec worker-1 "[ -f $BK/kubelet.conf ] && [ -f $BK/config.yaml ]"; then
  node_exec worker-1 "cp $BK/kubelet.conf /etc/kubernetes/kubelet.conf && cp $BK/config.yaml /var/lib/kubelet/config.yaml"
fi
node_exec worker-1 "systemctl restart kubelet"
kubectl wait --for=condition=Ready "node/$(node_name worker-1)" --timeout=180s
