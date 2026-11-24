# 사전 준비

## 장애 상황 만들기

worker-1 노드(kind: `cka-worker`)에 접속하여 kubelet 서비스를 중지한다. A100에서는 `setup/run.sh`가 대신 한다.

```bash
docker exec -it cka-worker bash
systemctl stop kubelet
exit
```

## 장애 확인

```bash
# 약 1분 후 NotReady 상태로 전환됨
kubectl get nodes
# NAME       STATUS     ROLES    AGE   VERSION
# cka-worker   NotReady   <none>   Xd    v1.34.x
```
