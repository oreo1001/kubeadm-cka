# Lab 14 - kubectl로 커스텀 리소스(CRD) 관리

## 시험 문제

### Task A: API 리소스 조회
클러스터에 설치된 모든 API 리소스 목록을 조회하고,
`networking.k8s.io` API 그룹에 속한 리소스만 필터링하여 `/tmp/networking-resources.txt`에 저장하시오.

### Task B: explain 활용
`kubectl explain`을 사용하여 다음 필드 정보를 조회하시오.

1. `Ingress`의 `spec.rules` 필드 → `/tmp/ingress-rules.txt`
2. `NetworkPolicy`의 `spec.ingress` 필드 → `/tmp/netpol-ingress.txt`
3. `HorizontalPodAutoscaler`의 `spec` 전체 → `/tmp/hpa-spec.txt`

### Task C: CRD 확인 (Gateway API 설치 후)
Gateway API CRD를 설치하고 추가된 커스텀 리소스 종류를 확인하시오.

---

- [풀이](solution/)
- [삭제](cleanup/)
