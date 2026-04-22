# Lab 15 - RBAC (Role 기반 접근 제어)

## 시험 문제

`dev` namespace에 `ci-bot` ServiceAccount가 존재한다.
다음 요구사항에 맞게 RBAC 리소스를 생성하시오.

- `ci-bot`이 `dev` namespace의 **Pod를 조회** (get, list, watch) 할 수 있어야 한다
- `ci-bot`이 `dev` namespace의 **Deployment를 생성/수정/삭제** 할 수 있어야 한다
- Role 이름: `ci-role`
- RoleBinding 이름: `ci-rolebinding`

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
