#!/usr/bin/env bash
set -euo pipefail
# 정리: master 노드 /root/.kube/config를 준비 직후 상태(admin.conf, 이름만 kubernetes)로 되돌리고 dev 리소스 삭제
node_exec master '
  set -e
  mkdir -p /root/.kube
  cp /etc/kubernetes/admin.conf /root/.kube/config
  sed -i -e "s/^  name: cka$/  name: kubernetes/" -e "s/^    cluster: cka$/    cluster: kubernetes/" -e "s/kubernetes-admin@cka/kubernetes-admin@kubernetes/g" /root/.kube/config
'
kubectl delete -f ../setup/setup.yaml --ignore-not-found
