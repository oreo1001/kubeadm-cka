# 풀이

## 풀이 명령어

```bash
# 1. dev-user의 token 추출
TOKEN=$(kubectl -n dev get secret dev-user-token \
  -o jsonpath='{.data.token}' | base64 -d)

# 2. 현재 클러스터 서버 주소 확인
kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'

# 3. kubeconfig에 사용자 추가
kubectl config set-credentials dev-user --token="$TOKEN"

# 4. 컨텍스트 추가
kubectl config set-context dev-context \
  --cluster=kubernetes \
  --user=dev-user \
  --namespace=dev

# 5. 현재 컨텍스트 변경
kubectl config use-context dev-context

# 6. 확인
kubectl config current-context
# dev-context

kubectl config get-contexts
# CURRENT   NAME          CLUSTER      AUTHINFO    NAMESPACE
# *         dev-context   kubernetes   dev-user    dev

kubectl get pods   # dev namespace의 pod 조회
```

## 핵심 개념

| 명령어 | 설명 |
|--------|------|
| `kubectl config set-credentials` | 사용자(인증 정보) 추가 |
| `kubectl config set-cluster` | 클러스터 정보 추가 |
| `kubectl config set-context` | 컨텍스트 추가 (cluster + user + namespace 조합) |
| `kubectl config use-context` | 현재 컨텍스트 변경 |
| `kubectl config get-contexts` | 전체 컨텍스트 목록 |
| `kubectl config view` | kubeconfig 전체 내용 출력 |

```yaml
# kubeconfig 구조
clusters:   # 클러스터 접속 정보 (server URL, CA)
users:      # 인증 정보 (token, cert)
contexts:   # cluster + user + namespace 조합
current-context: dev-context
```

- kubeconfig 기본 경로: `~/.kube/config`
- `KUBECONFIG` 환경변수로 다른 파일 지정 가능
- `--namespace` 플래그 없이 namespace 기본값 지정하려면 context에 설정
