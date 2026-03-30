# 풀이

## Task A

```bash
kubectl explain pod.spec.containers.livenessProbe > /tmp/liveness-explain.txt

# 재귀적으로 모든 하위 필드 조회
kubectl explain pod.spec.containers.livenessProbe --recursive > /tmp/liveness-explain-recursive.txt

cat /tmp/liveness-explain.txt
```

## Task B

```bash
kubectl explain deployment.spec.strategy > /tmp/strategy-explain.txt
cat /tmp/strategy-explain.txt
```

## Task C

```bash
kubectl explain pvc.spec.accessModes > /tmp/pvc-accessmodes.txt
cat /tmp/pvc-accessmodes.txt
```

## 유용한 explain 패턴

```bash
# 특정 리소스 최상위 필드 조회
kubectl explain pod
kubectl explain deployment
kubectl explain service

# 중첩 필드 조회
kubectl explain pod.spec
kubectl explain pod.spec.containers
kubectl explain pod.spec.containers.env

# 전체 스키마 재귀 조회
kubectl explain pod --recursive | grep -A 2 "livenessProbe"

# API 버전 명시
kubectl explain deployment.spec --api-version=apps/v1
```

## 핵심 개념

- `kubectl explain`은 Kubernetes API 스키마를 실시간으로 조회
- 시험 중 공식 문서 대신 `explain`으로 빠르게 필드 확인 가능
- `--recursive` 플래그로 전체 필드 트리 확인
- `KIND`, `VERSION`, `DESCRIPTION`, `FIELDS` 섹션으로 구성됨
