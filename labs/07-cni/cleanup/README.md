# 삭제

```bash
# Calico 제거 (CNI 변경 실습 시)
kubectl delete -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.0/manifests/calico.yaml
```

주의: 제거 후 노드가 NotReady 상태가 됩니다. 다른 CNI를 즉시 설치해야 합니다.
