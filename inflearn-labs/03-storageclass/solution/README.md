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
| `WaitForFirstConsumer` | Pod가 스케줄링될 때 PV 바인딩 — hostPath/local PV에 필수 |

| reclaimPolicy | PVC 삭제 후 동작 |
|---------------|----------------|
| `Retain` | PV 보존, 수동 정리 필요 |
| `Delete` | PV + 외부 스토리지 자동 삭제 |

- `no-provisioner`: 동적 프로비저닝 없음 → PV를 수동 생성해야 함
- 동적 프로비저닝: `rancher.io/local-path`, `ebs.csi.aws.com` 등 CSI 드라이버 사용
