# 풀이

## 풀이 명령어

```bash
# 마이그레이션 적용
kubectl apply -f solution.yaml

# 확인
kubectl get gateway web-gateway -n web
kubectl get httproute web-route -n web
kubectl describe gateway web-gateway -n web

# 접속 테스트
GATEWAY_IP=$(kubectl get svc -n nginx-gateway -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')
curl -k https://example.local --resolve example.local:443:$GATEWAY_IP
```

## 기존 Ingress vs 새 Gateway API 비교

| 구성 요소 | Ingress | Gateway API |
|-----------|---------|-------------|
| 진입점 정의 | Ingress 리소스 | Gateway 리소스 |
| 라우팅 규칙 | Ingress 리소스 | HTTPRoute 리소스 |
| TLS 설정 | Ingress.spec.tls | Gateway.spec.listeners.tls |
| 역할 분리 | 없음 | GatewayClass(인프라), Gateway(운영), Route(개발) |

## 핵심 개념

- `GatewayClass`: 어떤 컨트롤러를 사용할지 정의 (클러스터 전역)
- `Gateway`: 리스너(포트/프로토콜/TLS) 정의 (인프라 팀)
- `HTTPRoute`: URL 경로 라우팅 규칙 (개발 팀)
- `parentRefs`: HTTPRoute가 어떤 Gateway를 사용할지 지정
- TLS 모드: `Terminate`(Gateway에서 종료) / `Passthrough`(백엔드까지 전달)
