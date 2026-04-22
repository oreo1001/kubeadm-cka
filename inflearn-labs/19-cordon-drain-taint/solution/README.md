# 풀이

## 풀이 명령어

```bash
# 1. worker-2 cordon (새 Pod 스케줄 중단)
kubectl cordon worker-2

kubectl get nodes
# NAME       STATUS                     ROLES    AGE   VERSION
# worker-2   Ready,SchedulingDisabled   <none>   Xd    v1.31.x

# 2. worker-2 drain (기존 Pod 이동)
kubectl drain worker-2 \
  --ignore-daemonsets \
  --delete-emptydir-data

# drain 후 Pod 이동 확인 (nodeSelector 때문에 Pending 상태가 될 수 있음)
kubectl get pods -o wide

# 3. taint 추가
kubectl taint node worker-2 env=maintenance:NoSchedule

# taint 확인
kubectl describe node worker-2 | grep Taint
# Taints: env=maintenance:NoSchedule

# 4. taint를 tolerate하는 Pod 생성
kubectl apply -f solution.yaml

# Pod가 worker-2에 스케줄됐는지 확인
kubectl get pod maintenance-pod -o wide
# NAME              READY   STATUS    NODE
# maintenance-pod   1/1     Running   worker-2
```

## 핵심 개념

| 명령어 | 설명 |
|--------|------|
| `kubectl cordon <node>` | 노드를 SchedulingDisabled로 표시 (기존 Pod 유지) |
| `kubectl uncordon <node>` | 노드 스케줄 재개 |
| `kubectl drain <node>` | 노드의 Pod를 모두 이동 후 cordon |
| `kubectl taint node <node> key=value:Effect` | taint 추가 |
| `kubectl taint node <node> key=value:Effect-` | taint 제거 (끝에 `-`) |

### Taint Effect 종류

| Effect | 동작 |
|--------|------|
| `NoSchedule` | toleration 없는 Pod는 스케줄 안됨 (기존 Pod 유지) |
| `PreferNoSchedule` | 가능하면 스케줄 안함 (보장 아님) |
| `NoExecute` | toleration 없는 Pod는 즉시 퇴출 + 새 스케줄 안됨 |

```yaml
# Toleration 작성법
tolerations:
  - key: "env"
    operator: "Equal"
    value: "maintenance"
    effect: "NoSchedule"
```
