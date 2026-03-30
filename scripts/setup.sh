#!/bin/bash
# CKA 클러스터 전체 셋업 스크립트

set -e

echo "=== CKA 온프렘 클러스터 셋업 ==="
echo ""
echo "[사전 요구사항]"
echo "  - VirtualBox 설치 (Windows)"
echo "  - Vagrant 설치 (Windows)"
echo "  - Ansible 설치 (WSL2): pip install ansible"
echo "  - sshpass 설치 (WSL2): sudo apt install sshpass"
echo ""

# WSL2 확인
if ! command -v ansible &>/dev/null; then
  echo "ERROR: ansible이 설치되어 있지 않습니다."
  echo "실행: pip install ansible"
  exit 1
fi

if ! command -v sshpass &>/dev/null; then
  echo "ERROR: sshpass가 설치되어 있지 않습니다."
  echo "실행: sudo apt install sshpass"
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "[1/2] Ansible 플레이북 실행..."
cd "$PROJECT_ROOT/ansible"
ansible-playbook playbooks/setup_cluster.yml

echo ""
echo "[2/2] 완료!"
echo ""
echo "kubectl 사용법:"
echo "  export KUBECONFIG=$PROJECT_ROOT/kubeconfig"
echo "  kubectl get nodes"
