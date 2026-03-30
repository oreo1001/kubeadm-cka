# 사전 준비

별도 준비 리소스 없음.

## etcdctl 설치 확인

```bash
# kubeadm 클러스터에는 etcd Pod 내에 etcdctl 포함
kubectl exec -n kube-system etcd-master -- etcdctl version

# 또는 로컬에 설치
sudo apt-get install etcd-client
```
