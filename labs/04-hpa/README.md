# Lab 04 - Deployment에 HPA 생성

## 시험 문제

`default` namespace에 이미 `php-apache` Deployment가 배포되어 있다.
다음 요구사항에 맞는 HPA를 생성하시오.

- HPA 이름: `php-apache-hpa`
- 대상: `php-apache` Deployment
- 최소 replica: `1`
- 최대 replica: `5`
- CPU 사용률 목표: `50%`

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
