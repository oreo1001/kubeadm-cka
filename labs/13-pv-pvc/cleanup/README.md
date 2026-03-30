# 삭제

```bash
kubectl delete -f ../solution/solution.yaml
# PV는 Retain 정책이라 PVC 삭제 후에도 남아있음. 수동 삭제 필요
kubectl delete pv data-pv
```
