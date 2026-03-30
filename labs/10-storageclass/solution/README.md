# 풀이

## 풀이 명령어

```bash
kubectl apply -f solution.yaml

# 확인
kubectl get storageclass local-storage
kubectl describe storageclass local-storage
```

## 핵심 개념

| volumeBindingMode | 설명 |
|-------------------|------|
| `Immediate` | PVC 생성 즉시 PV 바인딩 (기본값) |
| `WaitForFirstConsumer` | Pod가 스케줄링될 때까지 PV 바인딩 지연 |

| reclaimPolicy | 설명 |
|---------------|------|
| `Retain` | PVC 삭제 후 PV 보존 (수동 정리 필요) |
| `Delete` | PVC 삭제 시 PV도 자동 삭제 |
| `Recycle` | deprecated |

- `no-provisioner`: 동적 프로비저닝 없음. PV를 수동으로 생성해야 함
- `WaitForFirstConsumer`: hostPath/local PV에 필수. Pod가 특정 노드에 스케줄된 후 해당 노드의 PV를 바인딩
