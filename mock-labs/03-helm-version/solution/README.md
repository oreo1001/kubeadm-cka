# 풀이

```bash
# 1
helm repo add podinfo https://stefanprodan.github.io/podinfo
helm repo update

# 2: 버전 목록에서 두 번째 줄 버전을 고른다
helm search repo podinfo/podinfo --versions | head -3
PREV=<두 번째 줄 CHART VERSION>
helm show values podinfo/podinfo | grep -nE '^replicaCount|^service:' -A3   # 키 이름 확인
helm install web podinfo/podinfo --version $PREV -n helm-lab --create-namespace \
  --set replicaCount=2 --set service.type=NodePort

# 3: --reuse-values 가 없으면 2단계 값(service.type)이 사라진다
helm upgrade web podinfo/podinfo -n helm-lab --reuse-values --set replicaCount=3

# 4
helm history web -n helm-lab
helm rollback web 1 -n helm-lab

# 5
helm get values web -n helm-lab > /tmp/web-values.yaml
cat /tmp/web-values.yaml          # replicaCount: 2, service.type: NodePort

kubectl -n helm-lab get deploy,svc
```

## 핵심

- `--version`을 빼면 항상 최신이 설치된다. 차트 버전(CHART VERSION)과 앱 버전(APP VERSION)은 다르다.
- `helm upgrade`는 기본으로 **이전 `--set` 값을 버린다**. 유지하려면 `--reuse-values`를 쓰거나 값을 다시 다 준다.
- 롤백도 새 리비전을 만든다. `history`에 리비전 3("Rollback to 1")이 생긴다.
- `helm get values`는 사용자 지정 값만, `helm get values --all`은 전체 값을 보여준다.
