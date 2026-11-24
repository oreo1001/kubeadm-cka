#!/usr/bin/env bash
set -euo pipefail
# 준비: dev namespace·dev-user SA·토큰 Secret 생성, master 노드에 /root/.kube/config 마련
# kind의 admin.conf는 클러스터 이름이 cka라서, 문제와 같게 cluster=kubernetes, context=kubernetes-admin@kubernetes로 바꿔 둔다

kubectl apply -f setup.yaml
log "dev-user-token 토큰 채워질 때까지 대기"
for _ in $(seq 1 30); do
  [ -n "$(kubectl -n dev get secret dev-user-token -o jsonpath='{.data.token}')" ] && break
  sleep 2
done
node_exec master '
  set -e
  mkdir -p /root/.kube
  cp /etc/kubernetes/admin.conf /root/.kube/config
  sed -i -e "s/^  name: cka$/  name: kubernetes/" -e "s/^    cluster: cka$/    cluster: kubernetes/" -e "s/kubernetes-admin@cka/kubernetes-admin@kubernetes/g" /root/.kube/config
  KUBECONFIG=/root/.kube/config kubectl config get-contexts
'
