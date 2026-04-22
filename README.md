# CKA 온프렘 실습 클러스터 (kubeadm)

Vagrant + VirtualBox로 온프렘 쿠버네티스 클러스터(1 Master + 3 Worker)를 구성하고,
Ansible로 kubeadm 설치를 자동화하는 CKA 시험 준비 프로젝트.

Linux(KVM/libvirt) 환경도 지원한다.

## 프로젝트 구조

```
.
├── Vagrantfile              # VM 프로비저닝 (Windows / VirtualBox)
├── linux/
│   └── Vagrantfile          # KVM/libvirt 환경
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/all.yml   # k8s 버전, CIDR 설정
│   ├── inventory/
│   │   ├── hosts.ini            # 현재 사용 중인 inventory
│   │   ├── hosts-linux.ini      # Linux IP 템플릿 (192.168.121.x)
│   │   └── hosts-windows.ini    # Windows IP 템플릿 (192.168.56.x)
│   ├── playbooks/
│   │   └── setup_cluster.yml
│   └── roles/
│       ├── common/          # swap off, containerd, kubeadm 설치
│       ├── master/          # kubeadm init, Calico CNI, kubeconfig
│       └── worker/          # kubeadm join
├── labs/                    # CKA 실습 문제 (14개)
├── inflearn-labs/           # 인프런 커리큘럼 기반 실습 (20개)
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

---

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
```

### 예상 출력

```
NAME       STATUS   ROLES           AGE   VERSION
master     Ready    control-plane   5m    v1.31.x
worker-1   Ready    <none>          3m    v1.31.x
worker-2   Ready    <none>          3m    v1.31.x
worker-3   Ready    <none>          3m    v1.31.x
```

---

## Linux 환경 (KVM/libvirt)

```bash
# 1. KVM + libvirt 설치
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients

# 2. Vagrant + libvirt 플러그인 설치
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install -y vagrant
vagrant plugin install vagrant-libvirt

# 3. 현재 유저를 libvirt/kvm 그룹에 추가
sudo usermod -aG libvirt,kvm $USER && newgrp libvirt

# 4. Ansible + sshpass 설치
sudo apt install -y ansible sshpass

# 5. 클러스터 설치
cd linux && vagrant up
cd ../ansible
cp inventory/hosts-linux.ini inventory/hosts.ini
ansible-playbook playbooks/setup_cluster.yml
```

---

## 클러스터 리셋

```bash
vagrant destroy -f
vagrant up

cd ansible && ansible-playbook playbooks/setup_cluster.yml
```

---

## labs/ 실습 목록

| No | 주제 | 디렉토리 |
|----|------|----------|
| 01 | PriorityClass 생성 및 Pod 연결 | [labs/01-priorityclass/](labs/01-priorityclass/) |
| 02 | 패키지 설치 (dpkg -i + systemctl) | [labs/02-dpkg-install/](labs/02-dpkg-install/) |
| 03 | Helm으로 ArgoCD 설치 | [labs/03-helm-argocd/](labs/03-helm-argocd/) |
| 04 | Deployment에 HPA 생성 | [labs/04-hpa/](labs/04-hpa/) |
| 05 | etcd 백업 / 복원 | [labs/05-etcd-backup/](labs/05-etcd-backup/) |
| 06 | NodePort 서비스 생성 | [labs/06-nodeport/](labs/06-nodeport/) |
| 07 | CNI 설치 | [labs/07-cni/](labs/07-cni/) |
| 08 | Sidecar 패턴 + Volume | [labs/08-sidecar/](labs/08-sidecar/) |
| 09 | NetworkPolicy 배포 | [labs/09-networkpolicy/](labs/09-networkpolicy/) |
| 10 | StorageClass 생성 | [labs/10-storageclass/](labs/10-storageclass/) |
| 11 | Pod 필터링 → 파일 저장 | [labs/11-pod-filter/](labs/11-pod-filter/) |
| 12 | explain 명령어 활용 | [labs/12-explain/](labs/12-explain/) |
| 13 | PV / PVC 생성 | [labs/13-pv-pvc/](labs/13-pv-pvc/) |
| 14 | Ingress → Gateway/HTTPRoute (TLS) 마이그레이션 | [labs/14-gateway-migration/](labs/14-gateway-migration/) |

## inflearn-labs/ 실습 목록

| No | 주제 | 디렉토리 |
|----|------|----------|
| 01 | ConfigMap 수정 (설정 관리) | [inflearn-labs/01-configmap/](inflearn-labs/01-configmap/) |
| 02 | HPA 생성 (부하에 따른 자동 확장) | [inflearn-labs/02-hpa/](inflearn-labs/02-hpa/) |
| 03 | StorageClass 생성 (동적 프로비저닝) | [inflearn-labs/03-storageclass/](inflearn-labs/03-storageclass/) |
| 04 | PVC 복구 (Released PV 재사용) | [inflearn-labs/04-pvc-recovery/](inflearn-labs/04-pvc-recovery/) |
| 05 | Service 생성 (L4 로드밸런싱) | [inflearn-labs/05-service/](inflearn-labs/05-service/) |
| 06 | Ingress 생성 (L7 경로 기반 라우팅) | [inflearn-labs/06-ingress/](inflearn-labs/06-ingress/) |
| 07 | Ingress → Gateway/HTTPRoute 전환 | [inflearn-labs/07-gateway-migration/](inflearn-labs/07-gateway-migration/) |
| 08 | NetworkPolicy (Pod 간 보안 통제) | [inflearn-labs/08-networkpolicy/](inflearn-labs/08-networkpolicy/) |
| 09 | 핵심 컴포넌트 장애 대응 | [inflearn-labs/09-core-components/](inflearn-labs/09-core-components/) |
| 10 | Sidecar 패턴 로그 수집 | [inflearn-labs/10-sidecar/](inflearn-labs/10-sidecar/) |
| 11 | 리소스 최적화 + PriorityClass | [inflearn-labs/11-resource-priority/](inflearn-labs/11-resource-priority/) |
| 12 | Helm으로 ArgoCD 배포 (GitOps) | [inflearn-labs/12-helm-argocd/](inflearn-labs/12-helm-argocd/) |
| 13 | CNI / CRI 설치 | [inflearn-labs/13-cni-cri/](inflearn-labs/13-cni-cri/) |
| 14 | kubectl로 CRD 관리 | [inflearn-labs/14-crd/](inflearn-labs/14-crd/) |
| 15 | RBAC (Role 기반 접근 제어) | [inflearn-labs/15-rbac/](inflearn-labs/15-rbac/) |
| 16 | Cluster Upgrade (kubeadm) | [inflearn-labs/16-cluster-upgrade/](inflearn-labs/16-cluster-upgrade/) |
| 17 | Node Troubleshooting (kubelet 장애 복구) | [inflearn-labs/17-node-troubleshooting/](inflearn-labs/17-node-troubleshooting/) |
| 18 | kubeconfig (사용자 컨텍스트 추가) | [inflearn-labs/18-kubeconfig/](inflearn-labs/18-kubeconfig/) |
| 19 | Cordon / Drain / Taint | [inflearn-labs/19-cordon-drain-taint/](inflearn-labs/19-cordon-drain-taint/) |
| 20 | Static Pod | [inflearn-labs/20-static-pod/](inflearn-labs/20-static-pod/) |

---

## 주의사항

- `vagrant up` 최초 실행 시 box 다운로드로 시간 소요 (약 1~2GB)
- Ansible은 WSL2에서 실행: `pip install ansible` + `sudo apt install sshpass`
- kubeadm은 노드당 최소 2 CPU, 2GB RAM 필요
- `serial: 1`: common role은 순차 실행 (containerd 설치 충돌 방지)
- kubeconfig 파일은 `./kubeconfig`에 자동 생성됨
- 환경 전환 시 `hosts.ini`와 `group_vars/all.yml`의 `master_ip` 두 곳 수정 필요

---

## 트러블슈팅

### ansible ping 실패

```bash
ssh -i ~/.vagrant.d/insecure_private_keys/vagrant.key.rsa vagrant@192.168.56.10
cd linux && vagrant ssh-config master
```

### kubeadm preflight 오류 — CPU

```bash
ssh vagrant@192.168.56.10 "nproc"
# 2 이상이어야 함
```

### Worker 노드 NotReady

```bash
kubectl get pods -n kube-system -l k8s-app=calico-node
kubectl describe node worker-1 | grep -A 10 Conditions
```
