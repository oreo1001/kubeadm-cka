# 풀이

## 풀이 명령어

```bash
kubectl apply -f solution.yaml

# 확인
kubectl get ingress -n web
kubectl describe ingress web-ingress -n web

# NodePort 번호 확인
NODE_PORT=$(kubectl get svc -n ingress-nginx ingress-nginx-controller \
  -o jsonpath='{.spec.ports[?(@.name=="http")].nodePort}')

# 접근 테스트
curl http://192.168.56.11:$NODE_PORT/
curl http://192.168.56.11:$NODE_PORT/api
```

## 핵심 개념

| pathType | 동작 |
|----------|------|
| `Prefix` | `/api` → `/api`, `/api/users` 모두 매칭 |
| `Exact` | `/api` → `/api`만 매칭 |

- Ingress Controller가 별도로 설치되어야 함 (클러스터 기본 내장 아님)
- `ingressClassName`: 어떤 Ingress Controller가 처리할지 지정

```yaml
spec:
  ingressClassName: nginx
  rules:
    - http:
        paths:
          - path: /api
            pathType: Prefix
            backend:
              service:
                name: api
                port:
                  number: 8080
```
