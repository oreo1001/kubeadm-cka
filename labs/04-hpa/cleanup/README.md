# 삭제

```bash
kubectl delete -f ../solution/solution.yaml
kubectl delete -f ../setup/setup.yaml
# metrics-server는 직접 설치했을 때만 지운다 (A100 kind 환경은 기본 구성이라 남긴다)
# kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```
