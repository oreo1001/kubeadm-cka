# 풀이

## 풀이 명령어

```bash
# 1. 현재 상태 확인
kubectl get nodes

# 2. CNI가 없는 이유 확인
kubectl describe node master | grep -A 5 "Conditions"
# KubeletNotReady: container runtime network not ready

# 3. Calico 설치
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml

# 4. Calico Pod 준비 대기
kubectl rollout status daemonset/calico-node -n kube-system --timeout=5m

# 5. 노드 상태 확인
kubectl get nodes
```

## 다른 CNI 옵션

```bash
# Flannel (단순한 오버레이 네트워크)
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

# Cilium (eBPF 기반, NetworkPolicy 고급 기능)
cilium install --version 1.16.0
```

## CNI 변경 방법

```bash
# 기존 CNI 제거
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
