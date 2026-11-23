#!/bin/bash
# Mock 05 고장 주입 — worker 노드에서 root로 실행
set -euo pipefail
BK=/root/cka-backup/mock05
mkdir -p "$BK"
cp -n /etc/kubernetes/kubelet.conf /var/lib/kubelet/config.yaml "$BK/"

# 1) API 서버 포트 오타
sed -i 's#\(server: https://[^:]*\):6443#\1:6553#' /etc/kubernetes/kubelet.conf
# 2) 클라이언트 CA 경로 오타
sed -i 's#clientCAFile: /etc/kubernetes/pki/ca.crt#clientCAFile: /etc/kubernetes/pki/ca-cert.crt#' /var/lib/kubelet/config.yaml
systemctl restart kubelet || true
echo "고장 주입 완료. 원본: $BK"
