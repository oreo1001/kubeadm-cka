# 풀이

## 1단계: control plane(master) 업그레이드

```bash
# master 노드에 SSH 접속
ssh vagrant@192.168.56.10

# kubeadm 업그레이드
sudo apt-mark unhold kubeadm
sudo apt-get update
sudo apt-get install -y kubeadm=1.32.0-1.1
sudo apt-mark hold kubeadm

kubeadm version

# 업그레이드 계획 확인
sudo kubeadm upgrade plan

# 업그레이드 실행
sudo kubeadm upgrade apply v1.32.0

# kubelet / kubectl 업그레이드
sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=1.32.0-1.1 kubectl=1.32.0-1.1
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet

exit
```

## 2단계: worker-1 업그레이드

```bash
# [WSL2] worker-1 drain
kubectl drain worker-1 --ignore-daemonsets --delete-emptydir-data

# worker-1 노드에 SSH 접속
ssh vagrant@192.168.56.11

sudo apt-mark unhold kubeadm
sudo apt-get update
sudo apt-get install -y kubeadm=1.32.0-1.1
sudo apt-mark hold kubeadm

# worker 노드 업그레이드 (apply 아닌 node)
sudo kubeadm upgrade node

sudo apt-mark unhold kubelet kubectl
sudo apt-get install -y kubelet=1.32.0-1.1 kubectl=1.32.0-1.1
sudo apt-mark hold kubelet kubectl
sudo systemctl daemon-reload
sudo systemctl restart kubelet

exit

# [WSL2] worker-1 uncordon
kubectl uncordon worker-1
```

## 완료 확인

```bash
kubectl get nodes
# NAME       STATUS   ROLES           AGE   VERSION
# master     Ready    control-plane   Xd    v1.32.x
# worker-1   Ready    <none>          Xd    v1.32.x
# ...
```

## 핵심 개념

| 단계 | 명령어 | 설명 |
|------|--------|------|
| 1 | `kubeadm upgrade plan` | 가능한 버전 및 변경사항 미리보기 |
| 2 | `kubeadm upgrade apply` | control plane 컴포넌트 업그레이드 |
| 3 | `kubeadm upgrade node` | worker 노드 설정 업그레이드 |
| 4 | `kubectl drain` | 업그레이드 전 Pod 이동 |
| 5 | `kubectl uncordon` | 업그레이드 후 스케줄 재개 |

- kubeadm, kubelet, kubectl은 **별도로 각각 업그레이드** 해야 한다
- `apt-mark hold/unhold`: 패키지 버전 고정/해제
- control plane 먼저, worker 순서로 진행 (순서 중요)
