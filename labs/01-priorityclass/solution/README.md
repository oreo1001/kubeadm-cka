# 풀이

## 풀이 명령어

```bash
# 매니페스트 적용
kubectl apply -f solution.yaml

# 확인
kubectl get priorityclass high-priority
kubectl get pod critical-nginx -o jsonpath='{.spec.priorityClassName}'
```

## 핵심 개념

- PriorityClass는 클러스터 전역 리소스 (namespace 없음)
- `value`가 높을수록 스케줄링 우선순위가 높음
- 기존 시스템 PriorityClass: `system-cluster-critical` (2000000000), `system-node-critical` (2000001000)
- 리소스 부족 시 낮은 우선순위 Pod가 먼저 축출(evict)됨
