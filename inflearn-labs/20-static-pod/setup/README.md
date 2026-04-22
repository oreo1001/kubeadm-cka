# 사전 준비

## Static Pod 경로 확인

```bash
# master 노드에 SSH 접속
ssh vagrant@192.168.56.10

# static pod manifest 경로 확인
sudo cat /var/lib/kubelet/config.yaml | grep staticPodPath
# staticPodPath: /etc/kubernetes/manifests

# 현재 static pod 목록 확인
ls /etc/kubernetes/manifests/
# etcd.yaml  kube-apiserver.yaml  kube-controller-manager.yaml  kube-scheduler.yaml

exit
```

> 별도 setup.yaml 없음 — master 노드의 파일시스템에 직접 작업
