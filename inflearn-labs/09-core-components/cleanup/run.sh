#!/usr/bin/env bash
set -euo pipefail
# 정리: kube-apiserver manifest 원복(백업 파일 제거), worker-1 kubelet 시작, 노드 Ready 대기

node_exec master '
  set -e
  m=/etc/kubernetes/manifests/kube-apiserver.yaml
  if [ -f /tmp/kube-apiserver.yaml.bak ]; then cp /tmp/kube-apiserver.yaml.bak "$m"; fi
  sed -i "s/--secure-port=9999/--secure-port=6443/" "$m"
  rm -f /tmp/kube-apiserver.yaml.bak
'
node_exec worker-1 "systemctl enable kubelet && systemctl start kubelet"

log "kube-apiserver 응답 대기"
for _ in $(seq 1 60); do
  kubectl get --raw=/readyz >/dev/null 2>&1 && break
  sleep 5
done
kubectl wait --for=condition=Ready nodes --all --timeout=300s
