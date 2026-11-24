#!/usr/bin/env bash
set -euo pipefail
# 정리: master 노드의 static-web manifest 삭제 (kubelet이 Pod를 자동 종료)

node_exec master "rm -f /etc/kubernetes/manifests/static-web.yaml"
