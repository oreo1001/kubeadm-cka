# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## 현재 상태 확인

```bash
kubectl get serviceaccount ci-bot -n dev
kubectl auth can-i get pods -n dev --as=system:serviceaccount:dev:ci-bot
# 결과: no (아직 권한 없음)
```
