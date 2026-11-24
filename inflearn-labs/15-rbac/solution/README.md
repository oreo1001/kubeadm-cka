# 풀이

## 풀이 명령어

```bash
# 방법 1: YAML 적용
kubectl apply -f solution.yaml

# 방법 2: 명령형으로 뼈대 → YAML로 규칙 나누기 (시험 권장)
# 주의: kubectl create role에 --verb/--resource를 여러 번 주면 "모든 verb × 모든 resource" 한 규칙이 된다.
#       그러면 Pod에도 create/delete가 생겨 권한이 넘친다. 규칙이 둘이면 YAML로 나눠 쓴다.
kubectl create role ci-role --verb=get,list,watch --resource=pods -n dev --dry-run=client -o yaml > role.yaml
# role.yaml의 rules에 두 번째 규칙을 추가:
#   - apiGroups: ["apps"]
#     resources: ["deployments"]
#     verbs: ["create", "update", "patch", "delete"]
kubectl apply -f role.yaml

kubectl create rolebinding ci-rolebinding \
  --role=ci-role \
  --serviceaccount=dev:ci-bot \
  -n dev

# 권한 확인
kubectl auth can-i get pods -n dev --as=system:serviceaccount:dev:ci-bot
# 결과: yes

kubectl auth can-i delete deployments -n dev --as=system:serviceaccount:dev:ci-bot
# 결과: yes

kubectl auth can-i delete pods -n default --as=system:serviceaccount:dev:ci-bot
# 결과: no (다른 namespace는 접근 불가)
```

## 핵심 개념

| 리소스 | 범위 | 설명 |
|--------|------|------|
| `Role` | namespace | 특정 namespace 내 리소스 권한 |
| `ClusterRole` | cluster 전체 | 모든 namespace 또는 cluster 리소스 권한 |
| `RoleBinding` | namespace | Role 또는 ClusterRole을 namespace 범위로 바인딩 |
| `ClusterRoleBinding` | cluster 전체 | ClusterRole을 cluster 전체 범위로 바인딩 |

```yaml
# Role: 어떤 리소스에 어떤 동작을 허용할지
rules:
  - apiGroups: [""]          # core API group (Pod, Service 등)
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["apps"]      # apps API group (Deployment 등)
    resources: ["deployments"]
    verbs: ["create", "update", "patch", "delete"]
```

- `kubectl auth can-i`: 권한 확인 명령어, `--as` 플래그로 특정 SA/유저 가장
- ServiceAccount 형식: `system:serviceaccount:<namespace>:<name>`
