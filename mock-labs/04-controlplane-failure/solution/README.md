# 풀이

A100 kind: static pod 이름 끝이 `-master` 대신 `-cka-control-plane`이다. 노드 접속: `docker exec -it cka-control-plane bash` (root라 `sudo` 불필요)

```bash
kubectl get pods -n kube-system            # scheduler, controller-manager가 CrashLoopBackOff/Error
kubectl get deploy,rs,pod -l app=cp-test   # RS/Pod가 없거나 Pending

# 원인 확인 (API 서버는 살아 있어서 kubectl logs가 된다)
kubectl -n kube-system logs kube-scheduler-master
kubectl -n kube-system logs kube-controller-manager-master
# 안 보이면 노드에서 직접
sudo crictl ps -a | grep -E 'scheduler|controller'
sudo crictl logs <container-id>

# 고치기: manifest를 고치면 kubelet이 알아서 다시 띄운다
sudo vi /etc/kubernetes/manifests/kube-scheduler.yaml           # - kube-schedulerr  ->  - kube-scheduler
sudo vi /etc/kubernetes/manifests/kube-controller-manager.yaml  # controller-manager.config -> .conf

watch kubectl get pods -n kube-system
kubectl get pod -l app=cp-test             # 3개 Running
```

## 핵심

- **controller-manager가 죽으면** Deployment가 있어도 ReplicaSet과 Pod가 **아예 안 생긴다**.
- **scheduler가 죽으면** Pod는 생기지만 `Pending`이고 `NODE`가 비어 있다.
- static pod는 `kubectl edit`로 못 고친다. `/etc/kubernetes/manifests/*.yaml`을 고친다.
- 로그 단서: `exec: "kube-schedulerr": executable file not found`, `stat /etc/kubernetes/controller-manager.config: no such file`.
- 고쳤는데 반영이 안 되면 manifest를 잠깐 디렉터리 밖으로 뺐다가 다시 넣는다.
