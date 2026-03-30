# Lab 08 - NetworkPolicy (포드 간 보안 통제)

## 시험 문제

`production` namespace에 다음 요구사항을 만족하는 NetworkPolicy를 생성하시오.

- 이름: `allow-frontend-to-backend`
- `role=backend` label을 가진 Pod에 적용
- Ingress: `role=frontend` label의 Pod만 TCP 8080 포트 허용
- 그 외 모든 Ingress 트래픽 차단
- Egress: 제한 없음

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
