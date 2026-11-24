#!/usr/bin/env bash
set -euo pipefail
# 준비: 없음 (master 노드의 staticPodPath와 현재 static pod 목록만 보여 준다)

node_exec master "grep staticPodPath /var/lib/kubelet/config.yaml; ls /etc/kubernetes/manifests/"
log "노드 접속: docker exec -it cka-control-plane bash"
