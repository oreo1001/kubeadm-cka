# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## 현재 상태 확인

```bash
kubectl config get-contexts
kubectl config current-context

# dev-user용 token 확인 (풀이에서 사용)
kubectl -n dev get secret dev-user-token -o jsonpath='{.data.token}' | base64 -d
```
