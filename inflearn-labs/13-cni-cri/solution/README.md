# 풀이

## Task A: Calico CNI 설치

```bash
# 현재 노드 상태 확인
kubectl get nodes
# STATUS: NotReady

# NotReady 원인 확인
kubectl describe node master | grep -A5 Conditions
# KubeletNotReady: container runtime network not ready

# Calico 설치
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

# 설치 완료 대기
kubectl rollout status daemonset/calico-node -n kube-system --timeout=5m

# 노드 Ready 확인
kubectl get nodes
```

## Task B: containerd 복구

```bash
# [worker-2에서]
sudo systemctl status containerd
sudo journalctl -u containerd -n 30 --no-pager

# containerd 재시작
sudo systemctl restart containerd
sudo systemctl enable containerd

# 정상 확인
sudo crictl info
sudo crictl ps
```

## 다른 CNI 옵션

```bash
# Flannel (단순한 오버레이)
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Cilium (eBPF 기반, NetworkPolicy 완전 지원)
cilium install --version 1.16.0
```

## 핵심 개념

### CNI (Container Network Interface)

- Pod 간 네트워크 통신을 담당하는 플러그인
- kubeadm은 CNI를 자동 설치하지 않음 → 수동 설치 필요
- 설정 위치: `/etc/cni/net.d/`
- 바이너리 위치: `/opt/cni/bin/`

### CRI (Container Runtime Interface)

- 컨테이너 런타임과 kubelet 사이의 인터페이스
- containerd, CRI-O 등이 CRI 구현체
- `crictl`: CRI 호환 런타임 직접 조작 도구 (kubectl 불가 시 사용)

```bash
crictl ps        # 실행 중인 컨테이너
crictl images    # 이미지 목록
crictl logs <id> # 컨테이너 로그
```
