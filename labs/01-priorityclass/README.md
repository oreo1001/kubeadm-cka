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

## 풀이

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

## 삭제
```bash
kubectl delete -f solution.yaml


kubectl delete pod critical-nginx
kubectl delete priorityclass high-priority
```