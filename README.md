# CKA 온프렘 실습 클러스터 (kubeadm)

Ubuntu 서버에서 KVM/libvirt + Vagrant로 VM 3개를 띄우고,
kubeadm으로 Kubernetes 클러스터(1 master + 2 worker)를 구성하는 CKA 시험 준비 프로젝트.

Windows(VirtualBox) 환경도 지원한다.

## 프로젝트 구조

```
.
├── linux/
│   └── Vagrantfile          # KVM/libvirt 환경 (기본)
├── windows/
│   └── Vagrantfile          # VirtualBox 환경
├── ansible/
│   ├── ansible.cfg
│   ├── group_vars/all.yml
│   ├── inventory/
│   │   ├── hosts.ini            # 현재 사용 중인 inventory
│   │   ├── hosts-linux.ini      # Linux IP 템플릿 (192.168.121.x)
│   │   └── hosts-windows.ini    # Windows IP 템플릿 (192.168.56.x)
│   ├── playbooks/
│   │   └── setup_cluster.yml
│   └── roles/
│       ├── common/
│       ├── master/
│       └── worker/
├── labs/                    # CKA 실습 문제 14개
└── scripts/
    ├── setup.sh
    └── reset.sh
```

## VM 스펙

| 역할     | CPU | RAM   |
|----------|-----|-------|
| master   | 2   | 2GB   |
| worker-1 | 1   | 1.5GB |
| worker-2 | 1   | 1.5GB |
| **합계** | **4** | **5GB** |

- OS: Ubuntu 22.04 LTS
- Kubernetes: v1.31 (kubeadm)
- CNI: Calico v3.28
- Container runtime: containerd

> master는 kubeadm 요구사항상 CPU 2개 미만이면 preflight 오류가 발생한다.
> worker는 1 CPU / 1.5GB RAM으로도 CKA 실습에 충분하다.
> ArgoCD 같이 무거운 워크로드는 worker에 배포되므로 master 메모리는 2GB면 충분하다.

---

## 사전 준비 (Linux / KVM)

```bash
# 1. KVM + libvirt 설치
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients

# 2. Vagrant + libvirt 플러그인 설치
sudo apt install -y vagrant
vagrant plugin install vagrant-libvirt

# 3. 현재 유저를 libvirt/kvm 그룹에 추가
sudo usermod -aG libvirt,kvm $USER
newgrp libvirt   # 또는 재로그인

# 4. Ansible + sshpass 설치
sudo apt install -y python3-pip sshpass
pip3 install ansible

# 5. 설치 확인
kvm-ok
vagrant --version
ansible --version
```

---

## 실행 순서

```bash
# 1. VM 시작
cd linux
vagrant up

# 2. inventory 설정
cd ../ansible
cp inventory/hosts-linux.ini inventory/hosts.ini

# 3. group_vars master_ip 확인 (기본값: 192.168.121.10)
# ansible/group_vars/all.yml 참고

# 4. SSH 키 배포
#    vagrant-libvirt가 생성한 키 경로 확인
vagrant ssh-config master | grep IdentityFile
#    출력 예: /home/user/.vagrant.d/insecure_private_keys/vagrant.key.rsa
#    ansible.cfg의 private_key_file을 해당 경로로 수정

# 5. 연결 확인
ansible all -m ping

# 6. 클러스터 설치 (~15분)
ansible-playbook playbooks/setup_cluster.yml

# 7. kubectl 사용
export KUBECONFIG=~/kubeadm-cka/kubeconfig
kubectl get nodes
```

### 예상 출력

```
NAME       STATUS   ROLES           AGE   VERSION
master     Ready    control-plane   5m    v1.31.x
worker-1   Ready    <none>          3m    v1.31.x
worker-2   Ready    <none>          3m    v1.31.x
```

---

## Windows 환경 (VirtualBox)

```powershell
# 1. VirtualBox / Vagrant 설치 후
cd windows
vagrant up
```

```bash
# 2. WSL2에서 Ansible 실행
sudo apt install -y python3-pip sshpass
pip3 install ansible

cd /path/to/kubeadm-cka/ansible
cp inventory/hosts-windows.ini inventory/hosts.ini
# group_vars/all.yml의 master_ip를 192.168.56.10으로 수정

ansible all -m ping
ansible-playbook playbooks/setup_cluster.yml

export KUBECONFIG=/path/to/kubeadm-cka/kubeconfig
kubectl get nodes
```

---

## 클러스터 리셋

```bash
cd linux   # 또는 windows
vagrant destroy -f && vagrant up

cd ../ansible
ansible-playbook playbooks/setup_cluster.yml
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
- 환경 전환 시 `hosts.ini`와 `group_vars/all.yml`의 `master_ip` 두 곳을 수정해야 함
- kubeadm master는 **CPU 2개 필수** (1개면 preflight 오류)

---

## 트러블슈팅

### ansible ping 실패

```bash
# SSH 직접 접속 테스트
ssh -i ~/.vagrant.d/insecure_private_keys/vagrant.key.rsa ubuntu@192.168.121.10

# vagrant ssh-config로 정확한 키 경로 확인
cd linux && vagrant ssh-config master
```

### kubeadm preflight 오류 — CPU

```bash
ssh ubuntu@192.168.121.10 "nproc"
# 2 이상이어야 함
```

### Worker 노드 NotReady

```bash
kubectl get pods -n kube-system -l k8s-app=calico-node
kubectl describe node worker-1 | grep -A 10 Conditions
```
