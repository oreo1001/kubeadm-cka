# 사전 준비

metrics-server가 없으면 `inflearn-labs/02-hpa/setup/README.md`의 설치 절차를 먼저 따른다.

```bash
kubectl apply -f setup.yaml
kubectl -n autoscale rollout status deploy/api
kubectl top pod -n autoscale   # 값이 나오면 준비 완료 (1~2분 걸릴 수 있음)
```
