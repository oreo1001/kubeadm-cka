# Lab 06 - NodePort 서비스 생성

## 시험 문제

`web` namespace에 다음을 생성하시오.

1. Deployment `web-app`
   - replicas: `2`
   - image: `nginx:latest`
   - containerPort: `80`

2. NodePort 서비스 `web-app-svc`
   - port: `80`
   - targetPort: `80`
   - nodePort: `30080`

---

- [풀이](solution/)
- [삭제](cleanup/)
