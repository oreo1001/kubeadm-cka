# 풀이

## 풀이 명령어

```bash
# Gateway API로 마이그레이션
kubectl apply -f solution.yaml

# 확인
kubectl get gateway web-gateway -n web
kubectl get httproute -n web
kubectl describe gateway web-gateway -n web

# 테스트
GATEWAY_IP=$(kubectl get svc -n nginx-gateway \
  -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
curl -k https://example.local --resolve example.local:443:$GATEWAY_IP
```

## 핵심 개념

| 구성 요소 | Ingress | Gateway API |
|-----------|---------|-------------|
| 진입점 | Ingress | Gateway |
| 라우팅 규칙 | Ingress.spec.rules | HTTPRoute |
| TLS 설정 | Ingress.spec.tls | Gateway.spec.listeners.tls |
| 역할 분리 | 없음 | GatewayClass / Gateway / Route |

- `GatewayClass`: 어떤 컨트롤러를 사용할지 (클러스터 전역)
- `Gateway`: 포트/프로토콜/TLS 정의 (인프라 팀 소유)
- `HTTPRoute`: URL 라우팅 규칙 (개발 팀 소유)
- `parentRefs.sectionName`: 특정 리스너(http/https)에 연결
