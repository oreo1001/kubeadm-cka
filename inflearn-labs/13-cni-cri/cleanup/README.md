# 삭제

별도 준비 리소스 없음. CNI 제거가 필요한 경우:

```bash
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
```

주의: CNI 제거 후 노드가 NotReady 상태가 됩니다. 다른 CNI를 즉시 설치해야 합니다.
