#!/usr/bin/env bash
set -euo pipefail
# 정리: worker-1(cka-worker) kubelet 시작·자동 시작 등록, Ready 대기

node_exec worker-1 "systemctl enable kubelet && systemctl start kubelet"
kubectl wait --for=condition=Ready node/cka-worker --timeout=300s
