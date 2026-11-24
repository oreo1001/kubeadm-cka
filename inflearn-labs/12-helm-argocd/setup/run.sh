#!/usr/bin/env bash
set -euo pipefail
# 준비: helm이 없으면 ~/.local/bin에 설치 (ArgoCD 설치는 문제 풀이 몫)

export PATH="$HOME/.local/bin:$PATH"
if ! command -v helm >/dev/null 2>&1; then
  log "helm 설치 → ~/.local/bin (sudo 없이)"
  mkdir -p "$HOME/.local/bin"
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    | HELM_INSTALL_DIR="$HOME/.local/bin" USE_SUDO=false bash
fi
helm version --short
