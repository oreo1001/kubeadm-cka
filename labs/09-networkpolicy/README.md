# Lab 09 - NetworkPolicy 배포

## 시험 문제

`production` namespace에 다음 요구사항을 만족하는 NetworkPolicy를 생성하시오.

- 이름: `allow-frontend-to-backend`
- `role=backend` label을 가진 Pod에 대해:
  - `role=frontend` label을 가진 Pod만 TCP 8080 포트로 접근 허용
  - 그 외 모든 Ingress 트래픽 차단
- Egress는 제한 없음

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
