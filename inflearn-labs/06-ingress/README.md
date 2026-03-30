# Lab 06 - Ingress 생성 (L7 경로 기반 라우팅)

## 시험 문제

`web` namespace에 `frontend` Service(port 80)와 `api` Service(port 8080)가 배포되어 있다.
다음 요구사항에 맞는 Ingress를 생성하시오.

- 이름: `web-ingress`
- namespace: `web`
- IngressClass: `nginx`
- 라우팅 규칙:
  - `/` (Prefix) → `frontend` Service, port `80`
  - `/api` (Prefix) → `api` Service, port `8080`
- host 미지정 (모든 호스트 허용)

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
