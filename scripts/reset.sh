#!/bin/bash
# 클러스터 리셋 (kubeadm reset + 재설치 준비)

set -e

echo "=== 클러스터 리셋 ==="
echo "주의: 모든 Kubernetes 데이터가 삭제됩니다."
read -p "계속하시겠습니까? (y/N): " confirm
[[ "$confirm" != "y" && "$confirm" != "Y" ]] && echo "취소." && exit 0

NODES=("worker-3" "worker-2" "worker-1" "master")

for node in "${NODES[@]}"; do
  echo "[$node] kubeadm reset 실행..."
  vagrant ssh "$node" -c "
    sudo kubeadm reset -f 2>/dev/null || true
    sudo rm -rf /etc/cni/net.d
    sudo rm -rf /var/lib/etcd
    sudo rm -rf /home/ubuntu/.kube
    sudo rm -f /tmp/kubeadm_join_command.sh
    sudo systemctl stop kubelet 2>/dev/null || true
  "
done

echo ""
echo "리셋 완료. 재설치:"
echo "  cd ansible && ansible-playbook playbooks/setup_cluster.yml"
