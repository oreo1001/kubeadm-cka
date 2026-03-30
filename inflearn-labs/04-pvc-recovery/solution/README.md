# 풀이

## 풀이 명령어

```bash
# 1단계: claimRef 제거 → Released → Available
kubectl patch pv old-data-pv \
  --type json \
  -p '[{"op":"remove","path":"/spec/claimRef"}]'

kubectl get pv old-data-pv  # STATUS: Available 확인

# 2단계: PVC + Pod 생성
kubectl apply -f solution.yaml

# 바인딩 확인
kubectl get pv,pvc
kubectl get pod data-pod
kubectl exec data-pod -- ls /data
```

## 핵심 개념

### PV 상태 전이

```
Available → [PVC 바인딩] → Bound → [PVC 삭제] → Released
Released  → [claimRef 제거] → Available (재사용 가능)
Released  → [reclaimPolicy: Delete] → 자동 삭제
```

### 특정 PV에 바인딩하는 방법

PVC에 `volumeName`을 지정하면 해당 PV에만 바인딩된다.

```yaml
spec:
  volumeName: old-data-pv  # 이 필드가 핵심
```
