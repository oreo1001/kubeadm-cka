# Lab 14 - Ingress → Gateway API / HTTPRoute (TLS) 마이그레이션

## 시험 문제

`web` namespace에 기존 Ingress가 배포되어 있다.
이를 Gateway API의 `Gateway` + `HTTPRoute`로 마이그레이션하시오.

요구사항:
- Gateway 이름: `web-gateway`
- gatewayClassName: `nginx`
- HTTPS (포트 443, TLS 종료)
- TLS 인증서: `web-tls-secret` Secret 사용
- HTTPRoute 이름: `web-route`
- 호스트: `example.local`
- 경로 `/` → `web-app-svc:80` 으로 라우팅
- HTTP(80) → HTTPS(443) 리다이렉트

## 사전 준비

```bash
# 1. Gateway API CRD 설치
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml

# 2. NGINX Gateway Fabric 설치
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/default/deploy.yaml

# 3. TLS 인증서 생성 (자체 서명)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key \
  -out /tmp/tls.crt \
  -subj "/CN=example.local/O=example"

kubectl create secret tls web-tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n web

# 4. 기존 Ingress 및 서비스 배포
kubectl apply -f setup.yaml
```

## 풀이

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

## 삭제

```bash
kubectl delete -f solution.yaml
kubectl delete -f setup.yaml
kubectl delete secret web-tls-secret -n web
kubectl delete namespace web

# Gateway API CRD 및 컨트롤러 제거
kubectl delete -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/default/deploy.yaml
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
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
