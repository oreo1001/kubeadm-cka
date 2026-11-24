# 삭제

kubeconfig 정리는 master 노드 안에서(노드 접속: `docker exec -it cka-control-plane bash`), 리소스 삭제는 호스트에서 한다.

```bash
# 컨텍스트 원복
kubectl config use-context kubernetes-admin@kubernetes

# dev-context 및 dev-user 제거
kubectl config delete-context dev-context
kubectl config delete-user dev-user

# 리소스 삭제
kubectl delete -f ../setup/setup.yaml
```
