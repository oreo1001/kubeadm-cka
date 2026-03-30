# 풀이

## 풀이 명령어

```bash
# 방법 1: kubectl edit (대화형)
kubectl edit configmap app-config

# 방법 2: kubectl patch (명령형 — 시험 권장)
kubectl patch configmap app-config \
  --type merge \
  -p '{"data":{"APP_COLOR":"green","APP_ENV":"production"}}'

# 방법 3: YAML 재적용
kubectl apply -f solution.yaml

# Deployment 재시작 (envFrom 방식은 자동 반영 안 됨)
kubectl rollout restart deployment web-app
kubectl rollout status deployment web-app

# 변경 확인
kubectl exec deploy/web-app -- env | grep APP
```

## 핵심 개념

| 마운트 방식 | 변경 반영 | 재시작 필요 여부 |
|-------------|-----------|-----------------|
| `envFrom` / `env.valueFrom` | Pod 재시작 후 반영 | `kubectl rollout restart` 필요 |
| `volumeMounts` (파일 마운트) | 약 1분 내 자동 반영 | 불필요 |

- `kubectl rollout restart`: 다운타임 없이 Rolling Update 방식으로 Pod 순차 재시작
- ConfigMap 이름은 유지하면서 `data` 필드만 수정하는 것이 핵심
