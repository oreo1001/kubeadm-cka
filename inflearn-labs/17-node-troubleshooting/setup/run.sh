#!/usr/bin/env bash
set -euo pipefail
# 준비(장애 주입): worker-1(cka-worker)의 kubelet 중지 → 약 1분 뒤 NotReady

node_exec worker-1 "systemctl stop kubelet"
log "worker-1(cka-worker) kubelet 중지. 약 1분 뒤 kubectl get nodes 에서 NotReady"
