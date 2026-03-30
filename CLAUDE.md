# CKA 온프렘 실습 클러스터

Vagrant + VirtualBox로 온프렘 쿠버네티스 클러스터(1 Master + 3 Worker)를 구성하고,
Ansible로 kubeadm 설치를 자동화하는 CKA 시험 준비 프로젝트.

## 프로젝트 구조

```
.
├── Vagrantfile              # VM 프로비저닝 (1 master + 3 worker)
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/all.yml   # k8s 버전, CIDR 설정
│   ├── inventory/hosts.ini  # 고정 IP (192.168.56.x)
│   ├── playbooks/
│   │   └── setup_cluster.yml
│   └── roles/
│       ├── common/          # swap off, containerd, kubeadm 설치
│       ├── master/          # kubeadm init, Calico CNI, kubeconfig
│       └── worker/          # kubeadm join
├── labs/                    # CKA 실습 문제 (14개)
│   ├── 01-priorityclass/
│   ├── 02-dpkg-install/
│   ├── 03-helm-argocd/
│   ├── 04-hpa/
│   ├── 05-etcd-backup/
│   ├── 06-nodeport/
│   ├── 07-cni/
│   ├── 08-sidecar/
│   ├── 09-networkpolicy/
│   ├── 10-storageclass/
│   ├── 11-pod-filter/
│   ├── 12-explain/
│   ├── 13-pv-pvc/
│   └── 14-gateway-migration/
└── scripts/
    ├── setup.sh             # Ansible 실행 래퍼
    └── reset.sh             # 클러스터 리셋
```

## 인프라 스펙

| 구분     | IP             | CPU | Memory |
|----------|----------------|-----|--------|
| master   | 192.168.56.10  | 2   | 4GB    |
| worker-1 | 192.168.56.11  | 2   | 2GB    |
| worker-2 | 192.168.56.12  | 2   | 2GB    |
| worker-3 | 192.168.56.13  | 2   | 2GB    |

- OS: Ubuntu 22.04 (ubuntu/jammy64)
- Kubernetes: v1.31
- CNI: Calico v3.28
- Container runtime: containerd

## 실행 환경

| 작업              | 환경             |
|-------------------|------------------|
| vagrant up/halt   | Windows (CMD/PS) |
| ansible-playbook  | WSL2             |
| kubectl           | WSL2             |

## 실행 순서

```bash
# [Windows] VM 시작
vagrant up

# [WSL2] 사전 요구사항 (최초 1회)
sudo apt install sshpass
pip install ansible

# [WSL2] 클러스터 설치
cd ansible
ansible-playbook playbooks/setup_cluster.yml

# [WSL2] kubectl 확인
export KUBECONFIG=./kubeconfig
kubectl get nodes

# [Windows] VM 삭제
vagrant destroy -f
```

## 클러스터 리셋

```bash
# [Windows] Vagrant VM 내에서
bash scripts/reset.sh

# 재설치
cd ansible && ansible-playbook playbooks/setup_cluster.yml
```

## CKA 실습 목록

| No | 주제 | 디렉토리 |
|----|------|----------|
| 01 | PriorityClass 생성 및 Pod 연결 | labs/01-priorityclass/ |
| 02 | 패키지 설치 (dpkg -i + systemctl) | labs/02-dpkg-install/ |
| 03 | Helm으로 ArgoCD 설치 | labs/03-helm-argocd/ |
| 04 | Deployment에 HPA 생성 | labs/04-hpa/ |
| 05 | etcd 백업 / 복원 | labs/05-etcd-backup/ |
| 06 | NodePort 서비스 생성 | labs/06-nodeport/ |
| 07 | CNI 설치 | labs/07-cni/ |
| 08 | Sidecar 패턴 + Volume | labs/08-sidecar/ |
| 09 | NetworkPolicy 배포 | labs/09-networkpolicy/ |
| 10 | StorageClass 생성 | labs/10-storageclass/ |
| 11 | Pod 필터링 → 파일 저장 | labs/11-pod-filter/ |
| 12 | explain 명령어 활용 | labs/12-explain/ |
| 13 | PV / PVC 생성 | labs/13-pv-pvc/ |
| 14 | Ingress → Gateway/HTTPRoute (TLS) 마이그레이션 | labs/14-gateway-migration/ |

## 주의사항

- `vagrant up` 최초 실행 시 box 다운로드로 시간 소요 (약 1~2GB)
- Ansible은 WSL2에서 실행: `pip install ansible` + `sudo apt install sshpass`
- kubeadm은 노드당 최소 2 CPU, 2GB RAM 필요
- `serial: 1`: common role은 순차 실행 (containerd 설치 충돌 방지)
- kubeconfig 파일은 `./kubeconfig`에 자동 생성됨
