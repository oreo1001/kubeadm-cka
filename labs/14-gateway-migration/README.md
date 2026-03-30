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

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
