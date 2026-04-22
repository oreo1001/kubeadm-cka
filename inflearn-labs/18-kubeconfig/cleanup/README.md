# 삭제

```bash
# 컨텍스트 원복
kubectl config use-context kubernetes-admin@kubernetes

# dev-context 및 dev-user 제거
kubectl config delete-context dev-context
kubectl config delete-user dev-user

# 리소스 삭제
kubectl delete -f ../setup/setup.yaml
```
