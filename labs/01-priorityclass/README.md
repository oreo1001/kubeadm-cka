# Lab 01 - PriorityClass 생성 및 Pod 연결

## 시험 문제

다음 요구사항에 맞게 PriorityClass와 Pod를 생성하시오.

1. 이름이 `high-priority`인 PriorityClass를 생성하시오.
   - value: `1000000`
   - globalDefault: `false`
   - description: "High priority for critical workloads"

2. 이름이 `critical-nginx`인 Pod를 `default` namespace에 생성하시오.
   - image: `nginx:latest`
   - 위에서 생성한 `high-priority` PriorityClass를 사용할 것

---

- [풀이](solution/)
- [삭제](cleanup/)