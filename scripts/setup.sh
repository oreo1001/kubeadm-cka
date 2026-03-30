#!/bin/bash
# CKA 클러스터 전체 셋업 스크립트
# 사용법: bash scripts/setup.sh
#
# 실행 위치: 프로젝트 루트 (kubeadm-cka/)
# 사전 요구사항 (최초 1회):
#   bash scripts/install-deps.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# ---------------------------------------------------------------
# 0. 사전 요구사항 확인
# ---------------------------------------------------------------
check_cmd() {
  if ! command -v "$1" &>/dev/null; then
    echo "ERROR: '$1' 가 설치되어 있지 않습니다."
    echo "       bash scripts/install-deps.sh 를 먼저 실행하세요."
    exit 1
  fi
}

check_cmd vagrant
check_cmd ansible
check_cmd ansible-playbook

# ---------------------------------------------------------------
# 1. VM 시작 (vagrant up)
# ---------------------------------------------------------------
echo "[1/4] VM 시작 (vagrant up)..."
cd "$PROJECT_ROOT/linux"

if vagrant status | grep -q "running"; then
  echo "  VM이 이미 실행 중입니다. 건너뜁니다."
else
  vagrant up
fi

# ---------------------------------------------------------------
# 2. inventory 설정
# ---------------------------------------------------------------
echo "[2/4] inventory 설정..."
cd "$PROJECT_ROOT/ansible"
cp inventory/hosts-linux.ini inventory/hosts.ini
echo "  hosts-linux.ini → hosts.ini 복사 완료"

# ---------------------------------------------------------------
# 3. Ansible 연결 확인
# ---------------------------------------------------------------
echo "[3/4] SSH 연결 확인..."
if ! ansible all -m ping; then
  echo ""
  echo "ERROR: 일부 노드에 SSH 연결이 안됩니다."
  echo "  - VM이 완전히 부팅됐는지 확인: cd linux && vagrant status"
  echo "  - 키 경로 확인: cd linux && vagrant ssh-config master"
  exit 1
fi

# ---------------------------------------------------------------
# 4. 클러스터 설치
# ---------------------------------------------------------------
echo "[4/4] 클러스터 설치 (kubeadm)... (~15분 소요)"
ansible-playbook playbooks/setup_cluster.yml

# ---------------------------------------------------------------
# 완료
# ---------------------------------------------------------------
echo ""
echo "======================================"
echo " 클러스터 설치 완료!"
echo "======================================"
echo ""
echo " kubectl 사용:"
echo "   export KUBECONFIG=$PROJECT_ROOT/kubeconfig"
echo "   kubectl get nodes"
echo ""
echo " 클러스터 리셋:"
echo "   bash $PROJECT_ROOT/scripts/reset.sh"
