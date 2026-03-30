# Lab 11 - 리소스 최적화 + PriorityClass

## 시험 문제

### 요구사항 1: LimitRange 및 ResourceQuota

`team-a` namespace에 다음을 생성하시오.

- LimitRange 이름: `team-a-limits`
  - Container 기본 request: CPU `100m`, Memory `128Mi`
  - Container 기본 limit: CPU `500m`, Memory `256Mi`
- ResourceQuota 이름: `team-a-quota`
  - 최대 Pod 수: `10`
  - CPU request 합계: `2`, Memory request 합계: `2Gi`

### 요구사항 2: PriorityClass

- PriorityClass 이름: `critical-priority`
- value: `1000000`
- globalDefault: `false`
- 위 PriorityClass를 사용하는 Pod `critical-pod` 생성 (image: `nginx:alpine`)

---

- [풀이](solution/)
- [삭제](cleanup/)
