# Lab 07 - CNI 설치

## 시험 문제

클러스터의 모든 노드가 `NotReady` 상태이다.
CNI 플러그인이 설치되지 않은 것이 원인이다.
Calico CNI를 설치하여 모든 노드를 `Ready` 상태로 만드시오.

## 풀이

```bash
# 1. 현재 상태 확인
kubectl get nodes
# NAME       STATUS     ROLES           AGE   VERSION
# master     NotReady   control-plane   5m    v1.31.x
# worker-1   NotReady   <none>          3m    v1.31.x

# 2. CNI가 없는 이유 확인
kubectl describe node master | grep -A 5 "Conditions"
# KubeletNotReady: container runtime network not ready

# 3. Calico 설치
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

# 4. Calico Pod 준비 대기
kubectl rollout status daemonset/calico-node -n kube-system --timeout=5m

# 5. 노드 상태 확인
kubectl get nodes
# NAME       STATUS   ROLES           AGE   VERSION
# master     Ready    control-plane   8m    v1.31.x
# worker-1   Ready    <none>          6m    v1.31.x
```

## 삭제

```bash
# Calico 제거 (CNI 변경 실습 시)
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
# 주의: 제거 후 노드가 NotReady가 됨. 다른 CNI를 바로 설치해야 함
```

## 다른 CNI 옵션

### Flannel (단순한 오버레이 네트워크)
```bash
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

### Cilium (eBPF 기반, NetworkPolicy 고급 기능)
```bash
curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
tar xzvf cilium-linux-amd64.tar.gz
sudo mv cilium /usr/local/bin
cilium install --version 1.16.0
```

## CNI 변경 방법

```bash
# 기존 CNI 제거 (Calico 예시)
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

# 각 노드에서 CNI 설정 파일 삭제
sudo rm -rf /etc/cni/net.d/*

# 새 CNI 설치
kubectl apply -f <new-cni-manifest>
```

## 핵심 개념

- CNI(Container Network Interface): Pod 간 통신을 위한 네트워크 플러그인
- `/etc/cni/net.d/` : CNI 설정 파일 위치
- `/opt/cni/bin/` : CNI 바이너리 위치
- kubeadm 클러스터는 CNI를 자동 설치하지 않음 (별도 설치 필요)
- `--pod-network-cidr` 값이 CNI 설정과 일치해야 함
