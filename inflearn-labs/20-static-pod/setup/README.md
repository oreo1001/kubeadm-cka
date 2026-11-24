# 사전 준비

## Static Pod 경로 확인

```bash
# master 노드 접속 (시험에서는 ssh master)
docker exec -it cka-control-plane bash

# static pod manifest 경로 확인 (노드 안은 root라 sudo 불필요)
cat /var/lib/kubelet/config.yaml | grep staticPodPath
# staticPodPath: /etc/kubernetes/manifests

# 현재 static pod 목록 확인
ls /etc/kubernetes/manifests/
# etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

exit
```

> 별도 setup.yaml 없음 — master 노드의 파일시스템에 직접 작업
