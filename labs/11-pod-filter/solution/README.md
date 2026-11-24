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
# "이름에 etcd가 포함"이고 컨테이너가 여러 개일 수 있으니, 첫 컨테이너 == 비교가 아니라 전체에서 찾는다.
# jsonpath 필터에는 '포함' 연산자가 없어서 Pod 이름과 컨테이너 이름을 뽑은 뒤 awk로 거른다.
kubectl get pods -n kube-system \
  -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.spec.containers[*].name}{"\n"}{end}' \
  | awk '{for (i=2;i<=NF;i++) if ($i ~ /etcd/) {print $1; break}}' \
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
