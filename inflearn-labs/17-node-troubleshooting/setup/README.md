# 사전 준비

## 장애 상황 만들기

worker-1 노드에 SSH 접속하여 kubelet 서비스를 중지한다.

```bash
ssh vagrant@192.168.56.11
sudo systemctl stop kubelet
exit
```

## 장애 확인

```bash
# 약 1분 후 NotReady 상태로 전환됨
kubectl get nodes
# NAME       STATUS     ROLES    AGE   VERSION
# worker-1   NotReady   <none>   Xd    v1.31.x
```
