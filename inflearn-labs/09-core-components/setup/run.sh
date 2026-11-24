#!/usr/bin/env bash
set -euo pipefail
# 준비(장애 주입): master의 kube-apiserver --secure-port를 9999로 망가뜨리고, worker-1의 kubelet을 멈춘다

log "worker-1(cka-worker): kubelet 중지"
node_exec worker-1 "systemctl stop kubelet"

log "master(cka-control-plane): kube-apiserver manifest 백업 후 --secure-port=9999 주입"
node_exec master '
  set -e
  m=/etc/kubernetes/manifests/kube-apiserver.yaml
  [ -f /tmp/kube-apiserver.yaml.bak ] || cp "$m" /tmp/kube-apiserver.yaml.bak
  sed -i "s/--secure-port=6443/--secure-port=9999/" "$m"
'
log "이제 kubectl이 안 된다(정상). 노드 접속: docker exec -it cka-control-plane bash"
