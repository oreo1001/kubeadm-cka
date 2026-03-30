#!/bin/bash
# 사전 요구사항 설치 스크립트 (최초 1회 실행)
# 사용법: bash scripts/install-deps.sh

set -e

echo "=== 사전 요구사항 설치 ==="

# ---------------------------------------------------------------
# 1. KVM + libvirt
# ---------------------------------------------------------------
echo "[1/4] KVM + libvirt 설치..."
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients libvirt-dev

# ---------------------------------------------------------------
# 2. Vagrant (HashiCorp 공식 저장소)
# ---------------------------------------------------------------
echo "[2/4] Vagrant 설치..."
if ! command -v vagrant &>/dev/null; then
  wget -O - https://apt.releases.hashicorp.com/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

  sudo apt update && sudo apt install -y vagrant
else
  echo "  vagrant 이미 설치됨. 건너뜁니다."
fi

echo "[2/4] vagrant-libvirt 플러그인 설치..."
if ! vagrant plugin list | grep -q vagrant-libvirt; then
  vagrant plugin install vagrant-libvirt
else
  echo "  vagrant-libvirt 이미 설치됨. 건너뜁니다."
fi

# ---------------------------------------------------------------
# 3. libvirt/kvm 그룹 추가
# ---------------------------------------------------------------
echo "[3/4] 유저 그룹 설정..."
sudo usermod -aG libvirt,kvm "$USER"
echo "  $USER → libvirt, kvm 그룹 추가 완료"

# ---------------------------------------------------------------
# 4. Ansible
# ---------------------------------------------------------------
echo "[4/4] Ansible 설치..."
sudo apt install -y ansible sshpass

# ---------------------------------------------------------------
# 완료
# ---------------------------------------------------------------
echo ""
echo "======================================"
echo " 설치 완료!"
echo "======================================"
echo ""
echo " 주의: 그룹 변경 적용을 위해 재로그인이 필요합니다."
echo "   newgrp libvirt   # 또는 터미널 재시작"
echo ""
echo " 확인:"
echo "   kvm-ok"
echo "   vagrant --version"
echo "   ansible --version"
echo ""
echo " 다음 단계:"
echo "   bash scripts/setup.sh"
