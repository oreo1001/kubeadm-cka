# Lab 03 - Helm으로 ArgoCD 설치

## 시험 문제

Helm을 사용하여 ArgoCD를 설치하시오.

1. `argocd` namespace를 생성하시오.
2. Argo Helm 저장소를 추가하시오. (https://argoproj.github.io/argo-helm)
3. `argo-cd` 차트를 `argocd` 네임스페이스에 `argocd`라는 이름으로 설치하시오.
4. ArgoCD 서버를 `NodePort`로 노출하시오. (nodePort: 30080)
5. 초기 admin 패스워드를 조회하시오.

---

- [풀이](solution/)
- [삭제](cleanup/)
