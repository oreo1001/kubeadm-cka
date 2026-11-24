#!/usr/bin/env bash
# Mock 05 준비: worker-1(cka-worker)의 kubelet 설정 2곳을 고장 냄 (break.sh 내용)
# ⚠️ 풀기 전에 이 파일을 보지 않는다.
set -euo pipefail

BREAK=$(cat <<'SH'
set -euo pipefail
BK=/root/cka-backup/mock05
mkdir -p "$BK"
[ -f "$BK/kubelet.conf" ] || cp /etc/kubernetes/kubelet.conf "$BK/"
[ -f "$BK/config.yaml" ] || cp /var/lib/kubelet/config.yaml "$BK/"
# 1) API 서버 포트 오타
sed -i 's#\(server: https://[^:]*\):6443#\1:6553#' /etc/kubernetes/kubelet.conf
# 2) 클라이언트 CA 경로 오타
sed -i 's#clientCAFile: /etc/kubernetes/pki/ca.crt#clientCAFile: /etc/kubernetes/pki/ca-cert.crt#' /var/lib/kubelet/config.yaml
systemctl restart kubelet || true
echo "고장 주입 완료. 원본: $BK"
SH
)

# kind 노드 이미지에는 편집기가 없을 수 있다 (kubelet 설정 수정용)
node_exec worker-1 "command -v vi >/dev/null || { apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq vim-tiny >/dev/null; }"
node_exec worker-1 "$BREAK"
log "준비 완료: 1~2분 뒤 kubectl get nodes 에서 cka-worker(문제의 worker-1)가 NotReady가 됩니다"
