# 삭제

```bash
# taint 제거
kubectl taint node worker-2 env=maintenance:NoSchedule-

# uncordon
kubectl uncordon worker-2

# 리소스 삭제
kubectl delete -f ../solution/solution.yaml
kubectl delete -f ../setup/setup.yaml
```
