# Lab 12 - Helm으로 ArgoCD 배포 (GitOps 입문)

## 시험 문제

Helm을 사용하여 ArgoCD를 설치하시오.

1. `argocd` namespace 생성
2. Helm 저장소 추가: `https://argoproj.github.io/argo-helm`
3. `argo-cd` 차트를 `argocd` namespace에 `argocd` 이름으로 설치
4. ArgoCD 서버를 `NodePort`로 노출 (nodePort: `30080`)
5. 초기 admin 패스워드 조회

---

- [풀이](solution/)
- [삭제](cleanup/)
