# 풀이

## 풀이 명령어

```bash
kubectl apply -f solution.yaml

# 확인
kubectl describe networkpolicy allow-frontend-to-backend -n production

# 허용 테스트: frontend → backend (성공해야 함)
kubectl exec -n production frontend -- curl -s --connect-timeout 3 http://backend:8080

# 차단 테스트: blocked-pod → backend (실패해야 함)
kubectl exec -n production blocked-pod -- curl -s --connect-timeout 3 http://backend:8080
```

## 핵심 개념

- NetworkPolicy는 CNI가 지원해야 동작 (Calico, Cilium ✅ / Flannel ❌)
- NetworkPolicy가 **없으면**: 모든 트래픽 허용 (기본)
- NetworkPolicy가 **하나라도 적용되면**: 명시된 트래픽만 허용, 나머지 차단

```yaml
spec:
  podSelector:
    matchLabels:
      role: backend
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              role: frontend
      ports:
        - protocol: TCP
          port: 8080
```

| 셀렉터 조합 | 의미 |
|------------|------|
| `podSelector` 만 | 같은 namespace의 Pod |
| `namespaceSelector` 만 | 특정 namespace의 모든 Pod |
| 두 개 같이 (AND) | 특정 namespace의 특정 Pod |
