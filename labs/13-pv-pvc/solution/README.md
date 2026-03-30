# 풀이

## 풀이 명령어

```bash
kubectl apply -f solution.yaml

# 확인
kubectl get pv data-pv
kubectl get pvc data-pvc

# PVC 바인딩 상태 확인 (Bound이어야 함)
kubectl get pvc data-pvc -o jsonpath='{.status.phase}'
```

## PVC를 Pod에 마운트하는 예시

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: pvc-test-pod
spec:
  volumes:
    - name: data-volume
      persistentVolumeClaim:
        claimName: data-pvc
  containers:
    - name: app
      image: nginx:latest
      volumeMounts:
        - name: data-volume
          mountPath: /data
```

## 핵심 개념

| accessMode | 약어 | 설명 |
|------------|------|------|
| ReadWriteOnce | RWO | 하나의 노드에서 읽기/쓰기 |
| ReadOnlyMany | ROX | 여러 노드에서 읽기만 |
| ReadWriteMany | RWX | 여러 노드에서 읽기/쓰기 |
| ReadWriteOncePod | RWOP | 하나의 Pod에서만 읽기/쓰기 |

- PV는 클러스터 전역 리소스 (namespace 없음)
- PVC는 namespace 리소스
- `WaitForFirstConsumer` StorageClass에서는 Pod 스케줄링 후 바인딩됨
