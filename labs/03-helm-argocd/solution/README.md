# 풀이

## 풀이 명령어

```bash
# 1. Helm 설치 (미설치 시)
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# 2. namespace 생성
kubectl create namespace argocd

# 3. Helm repo 추가
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# 4. ArgoCD 설치
helm install argocd argo/argo-cd \
  --namespace argocd \
  --values values.yaml

# 또는 NodePort를 인라인으로 설정
helm install argocd argo/argo-cd \
  --namespace argocd \
  --set server.service.type=NodePort \
  --set server.service.nodePortHttp=30080

# 5. 설치 확인
kubectl get pods -n argocd
kubectl get svc -n argocd

# 6. 초기 admin 패스워드 조회
kubectl get secret argocd-initial-admin-secret \
  -n argocd \
  -o jsonpath='{.data.password}' | base64 -d && echo

# 접속: http://192.168.56.10:30080  (admin / 위 패스워드)
```

## 핵심 Helm 명령어

| 명령어 | 설명 |
|--------|------|
| `helm repo add <name> <url>` | 저장소 추가 |
| `helm repo update` | 저장소 목록 갱신 |
| `helm search repo <keyword>` | 차트 검색 |
| `helm install <release> <chart>` | 설치 |
| `helm upgrade <release> <chart>` | 업그레이드 |
| `helm uninstall <release>` | 삭제 |
| `helm list -A` | 설치된 릴리스 목록 |
| `helm get values <release>` | 적용된 values 확인 |
| `helm show values <chart>` | 차트 기본 values 확인 |
