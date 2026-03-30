# CKA 온프렘 실습 클러스터 (kubeadm)

Ubuntu 서버 4대에 kubeadm으로 Kubernetes 클러스터(1 Master + 3 Worker)를 구성하는 CKA 시험 준비 프로젝트.

## 프로젝트 구조

```
.
├── Vagrantfile              # 로컬 VM 실습 시 사용 (선택사항)
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/all.yml   # k8s 버전, CIDR 설정
│   ├── inventory/hosts.ini  # 서버 IP 입력
│   ├── playbooks/
│   │   └── setup_cluster.yml
│   └── roles/
│       ├── common/          # swap off, containerd, kubeadm 설치
│       ├── master/          # kubeadm init, Calico CNI, kubeconfig
│       └── worker/          # kubeadm join
├── labs/                    # CKA 실습 문제 14개
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

| 역할     | 권장 사양       | 비고 |
|----------|-----------------|------|
| master   | 2 CPU / 4GB RAM | kubeadm init |
| worker-1 | 2 CPU / 2GB RAM | kubeadm join |
| worker-2 | 2 CPU / 2GB RAM | kubeadm join |
| worker-3 | 2 CPU / 2GB RAM | kubeadm join |

- OS: Ubuntu 22.04 LTS (Jammy)
- Kubernetes: v1.31
- CNI: Calico v3.28
- Container runtime: containerd

---

## 사전 준비

### 1. Ansible 설치 (컨트롤 노드 = 작업하는 Ubuntu 서버)

```bash
# pip로 설치 (권장)
sudo apt update
sudo apt install -y python3 python3-pip sshpass
pip3 install ansible

# 또는 apt로 설치
sudo apt install -y ansible

# 설치 확인
ansible --version
```

### 2. SSH 키 생성 및 배포

컨트롤 노드에서 모든 타깃 노드로 패스워드 없이 SSH 접속이 가능해야 한다.

```bash
# SSH 키 생성 (없는 경우)
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""

# 각 노드에 공개키 복사
ssh-copy-id ubuntu@<master-ip>
ssh-copy-id ubuntu@<worker-1-ip>
ssh-copy-id ubuntu@<worker-2-ip>
ssh-copy-id ubuntu@<worker-3-ip>

# 접속 확인
ssh ubuntu@<master-ip> "hostname"
```

> SSH 키 복사 시 타깃 노드의 ubuntu 계정 패스워드가 필요하다.
> `ssh-copy-id` 대신 아래 방법도 가능하다:
> ```bash
> cat ~/.ssh/id_rsa.pub | ssh ubuntu@<ip> "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
> ```

### 3. Inventory 파일 수정

`ansible/inventory/hosts.ini`에 실제 서버 IP를 입력한다.

```ini
[master]
master ansible_host=<master-ip>

[workers]
worker-1 ansible_host=<worker-1-ip>
worker-2 ansible_host=<worker-2-ip>
worker-3 ansible_host=<worker-3-ip>
```

---

## 실행 순서

```bash
# 프로젝트 루트로 이동
cd ~/kubeadm-cka

# 1. Inventory 연결 확인
ansible all -m ping -i ansible/inventory/hosts.ini

# 2. 클러스터 설치 (~15분)
cd ansible
ansible-playbook playbooks/setup_cluster.yml

# 3. kubectl 사용
export KUBECONFIG=~/kubeadm-cka/kubeconfig
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

## 클러스터 리셋

```bash
bash scripts/reset.sh

# 재설치
cd ansible && ansible-playbook playbooks/setup_cluster.yml
```

---

## CKA 실습 목록

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

---

## 주의사항

- `ansible-playbook`은 `ansible/` 디렉토리 안에서 실행해야 `ansible.cfg`가 적용됨
- `serial: 1` — common role은 순차 실행 (containerd 설치 충돌 방지)
- kubeadm은 노드당 최소 **2 CPU, 2GB RAM** 필요 (미달 시 `preflight error`)
- `kubeconfig`는 `ansible-playbook` 완료 후 프로젝트 루트에 자동 생성됨
- Ubuntu 22.04 기준. 24.04는 containerd 설정이 일부 다를 수 있음

---

## 트러블슈팅

### ansible ping 실패

```bash
# SSH 접속 가능한지 먼저 확인
ssh ubuntu@<ip>

# 패스워드 인증이 필요한 경우 sshpass 방식으로 임시 실행
ansible all -m ping -k   # SSH 패스워드 입력 프롬프트
```

### kubeadm init 실패 — "number of CPUs ... is less than the minimum"

```bash
# 노드 CPU 확인
ssh ubuntu@<master-ip> "nproc"
# 2 이상이어야 함
```

### kubeadm init 실패 — swap is enabled

```bash
# 노드에서 직접 확인
ssh ubuntu@<master-ip> "sudo swapon --show"
# 출력이 있으면 common role이 실패한 것 → 수동 실행
ssh ubuntu@<master-ip> "sudo swapoff -a"
```

### Worker 노드가 Ready 상태가 되지 않음

```bash
# CNI Pod 상태 확인
kubectl get pods -n kube-system -l k8s-app=calico-node

# 노드 상세 조건 확인
kubectl describe node worker-1 | grep -A 10 Conditions
```
