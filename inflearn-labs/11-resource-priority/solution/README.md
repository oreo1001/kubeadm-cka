# 풀이

## 사전 준비

```bash
kubectl create namespace team-a
```

## 풀이 명령어

```bash
kubectl apply -f solution.yaml

# LimitRange 확인
kubectl describe limitrange team-a-limits -n team-a

# ResourceQuota 확인
kubectl describe resourcequota team-a-quota -n team-a

# resources 미지정 Pod → LimitRange 기본값 자동 적용 확인
kubectl run test-pod --image=nginx:alpine -n team-a
kubectl describe pod test-pod -n team-a | grep -A6 Limits

# PriorityClass 확인
kubectl get priorityclass critical-priority
kubectl get pod critical-pod -o jsonpath='{.spec.priorityClassName}'
```

## 핵심 개념

### LimitRange vs ResourceQuota

| 항목 | LimitRange | ResourceQuota |
|------|-----------|---------------|
| 적용 대상 | 개별 Pod/Container | Namespace 전체 합산 |
| 기본값 설정 | 가능 | 불가 |
| 목적 | 단일 리소스 범위 제한 | Namespace 총 사용량 제한 |

### PriorityClass

- value가 높을수록 스케줄링 우선순위 높음
- 리소스 부족 시 낮은 우선순위 Pod를 **선점(Preemption)** 하여 축출
- 시스템 컴포넌트: `system-cluster-critical` (2000001000), `system-node-critical` (2000000000)

```
resources.requests → 스케줄링 보장량 (노드에 반드시 확보)
resources.limits   → 최대 사용량 (CPU: throttle / Memory: OOMKill)
```
