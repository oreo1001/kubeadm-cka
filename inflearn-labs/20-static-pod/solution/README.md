# 풀이

## 풀이 명령어

```bash
# master 노드에 SSH 접속
ssh vagrant@192.168.56.10

# static pod manifest 작성
sudo tee /etc/kubernetes/manifests/static-web.yaml << 'EOF'
apiVersion: v1
kind: Pod
metadata:
  name: static-web
  namespace: default
spec:
  containers:
    - name: nginx
      image: nginx:alpine
      ports:
        - containerPort: 80
EOF

# kubelet이 자동으로 감지하여 Pod 생성 (약 10~30초)
exit

# [WSL2] Pod 확인 — 이름이 static-web-master 형태로 생성됨
kubectl get pod static-web-master
# NAME               READY   STATUS    RESTARTS   AGE
# static-web-master  1/1     Running   0          30s
```

## 핵심 개념

| 항목 | 설명 |
|------|------|
| Static Pod란 | kubelet이 직접 관리하는 Pod (API 서버 없이도 동작) |
| manifest 경로 | `/etc/kubernetes/manifests/` |
| Pod 이름 규칙 | `<name>-<nodename>` (예: `static-web-master`) |
| 삭제 방법 | manifest 파일을 삭제하면 Pod 자동 종료 |
| `kubectl delete`로 삭제? | 불가 — 파일이 있는 한 kubelet이 재생성 |

- kube-apiserver, etcd, scheduler, controller-manager도 모두 static pod
- `kubectl get pod`에 표시되지만 `kubectl delete`로 영구 삭제 불가
- manifest 경로는 `/var/lib/kubelet/config.yaml`의 `staticPodPath`에서 확인

```bash
# staticPodPath 변경 후에는 kubelet 재시작 필요
sudo systemctl restart kubelet
```
