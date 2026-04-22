# 사전 준비

## 현재 버전 확인

```bash
kubectl get nodes
# NAME       STATUS   ROLES           AGE   VERSION
# master     Ready    control-plane   Xd    v1.31.x
# worker-1   Ready    <none>          Xd    v1.31.x
# worker-2   Ready    <none>          Xd    v1.31.x
# worker-3   Ready    <none>          Xd    v1.31.x

kubeadm version
kubectl version --short
```

## 업그레이드 가능 버전 확인 (master 노드에서)

```bash
ssh vagrant@192.168.56.10

sudo apt-cache madison kubeadm | grep 1.32
# kubeadm | 1.32.x-* | https://pkgs.k8s.io/...
```

> 별도 setup.yaml 없음 — 기존 클러스터 상태 그대로 진행
