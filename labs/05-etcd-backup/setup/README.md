# 사전 준비

별도 준비 리소스 없음.

노드 접속: `docker exec -it cka-control-plane bash` (문제의 `master`. 노드 안에서는 root라 `sudo`가 필요 없다)

## etcdctl 설치 확인

```bash
# A100 kind: setup/run.sh가 master 노드에 etcd와 같은 버전의 etcdctl · etcdutl을 넣어 둔다
etcdctl version
etcdutl version

# etcd Pod 이름은 etcd-<노드 이름> (kind: etcd-cka-control-plane)
kubectl -n kube-system get pod -l component=etcd
```
