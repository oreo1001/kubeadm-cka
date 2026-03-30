# Lab 13 - PV / PVC 생성

## 시험 문제

다음 요구사항에 맞게 PersistentVolume과 PersistentVolumeClaim을 생성하시오.

**PersistentVolume** (`data-pv`):
- capacity: `2Gi`
- accessModes: `ReadWriteOnce`
- reclaimPolicy: `Retain`
- storageClassName: `local-storage`
- hostPath: `/mnt/data`

**PersistentVolumeClaim** (`data-pvc`):
- namespace: `default`
- storage 요청: `1Gi`
- accessModes: `ReadWriteOnce`
- storageClassName: `local-storage`

PVC가 PV에 바인딩되는지 확인하시오.

## 사전 준비

```bash
# master 노드에서 hostPath 디렉토리 생성
sudo mkdir -p /mnt/data

# StorageClass 생성 (lab 10 선행 필요)
kubectl apply -f ../10-storageclass/solution.yaml
```

## 풀이

```bash
kubectl apply -f solution.yaml

# 확인
kubectl get pv data-pv
kubectl get pvc data-pvc

# PVC 바인딩 상태 확인 (Bound이어야 함)
kubectl get pvc data-pvc -o jsonpath='{.status.phase}'
```

## 삭제

```bash
kubectl delete -f solution.yaml
# PV는 Retain 정책이라 PVC 삭제 후에도 남아있음. 수동 삭제 필요
kubectl delete pv data-pv
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
