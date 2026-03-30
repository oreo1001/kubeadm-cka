# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## 현재 상태 확인

```bash
kubectl get configmap app-config -o yaml
kubectl exec deploy/web-app -- env | grep APP
```
