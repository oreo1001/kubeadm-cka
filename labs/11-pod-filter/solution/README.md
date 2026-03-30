# 풀이

## Task A: Running 상태 Pod

```bash
# 방법 1: --field-selector
kubectl get pods -n kube-system \
  --field-selector=status.phase=Running \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
  > /tmp/running-pods.txt

# 방법 2: custom-columns
kubectl get pods -n kube-system \
  --field-selector=status.phase=Running \
  -o custom-columns=NAME:.metadata.name \
  --no-headers \
  > /tmp/running-pods.txt

cat /tmp/running-pods.txt
```

## Task B: Label 필터

```bash
kubectl get pods --all-namespaces \
  -l app=nginx \
  -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace \
  --no-headers \
  > /tmp/nginx-pods.txt

cat /tmp/nginx-pods.txt
```

## Task C: 컨테이너 이름 필터 (jsonpath)

```bash
# Pod 이름만 저장
kubectl get pods -n kube-system \
  -o jsonpath='{range .items[?(@.spec.containers[0].name=="etcd")]}{.metadata.name}{"\n"}{end}' \
  > /tmp/etcd-pods.txt
```

## 핵심 명령어

| 옵션 | 설명 |
|------|------|
| `-l key=value` | Label selector |
| `--field-selector` | 필드 기반 필터 (status.phase, metadata.namespace 등) |
| `-o jsonpath=...` | JSONPath로 특정 필드 추출 |
| `-o custom-columns=...` | 커스텀 컬럼 출력 |
| `--no-headers` | 헤더 제거 |
| `--sort-by=.metadata.name` | 정렬 |
