# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## 현재 상태 확인

```bash
# worker-2에 Pod가 배포된 것 확인
kubectl get pods -o wide | grep worker-2
```
