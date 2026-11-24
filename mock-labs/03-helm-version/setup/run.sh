#!/usr/bin/env bash
# Mock 03 준비: 호스트에 helm(사용자 홈 ~/.local/bin)이 없으면 설치
set -euo pipefail
export PATH="$HOME/.local/bin:$PATH"
if ! command -v helm >/dev/null 2>&1; then
  log "helm 설치 (~/.local/bin, sudo 없음)"
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    | HELM_INSTALL_DIR="$HOME/.local/bin" USE_SUDO=false bash
fi
helm version --short
log "준비 완료: podinfo 저장소 추가부터 시작하세요"
