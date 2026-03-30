# 풀이

## Task A: API 리소스 조회

```bash
# 모든 API 리소스 조회
kubectl api-resources

# networking.k8s.io 그룹 필터링
kubectl api-resources --api-group=networking.k8s.io \
  > /tmp/networking-resources.txt

cat /tmp/networking-resources.txt
```

## Task B: explain 활용

```bash
# Ingress spec.rules
kubectl explain ingress.spec.rules > /tmp/ingress-rules.txt

# NetworkPolicy spec.ingress
kubectl explain networkpolicy.spec.ingress > /tmp/netpol-ingress.txt

# HPA spec 전체 (재귀)
kubectl explain hpa.spec --recursive > /tmp/hpa-spec.txt

# 파일 확인
cat /tmp/ingress-rules.txt
```

## Task C: Gateway API CRD

```bash
# Gateway API CRD 설치
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml

# 추가된 CRD 확인
kubectl get crd | grep gateway

# Gateway API 리소스 조회
kubectl api-resources | grep gateway

# GatewayClass 목록
kubectl get gatewayclass
```

## 핵심 개념

### kubectl explain 사용법

```bash
# 기본 사용
kubectl explain <resource>
kubectl explain <resource>.<field>.<subfield>

# 전체 필드 트리
kubectl explain <resource> --recursive

# API 버전 명시
kubectl explain deployment --api-version=apps/v1
```

### 유용한 조회 패턴 (시험 중)

```bash
# 어떤 리소스가 있는지 모를 때
kubectl api-resources | grep <keyword>

# 필드 이름이 기억 안 날 때
kubectl explain pod.spec --recursive | grep <keyword>

# 허용되는 값 확인
kubectl explain pvc.spec.accessModes
kubectl explain pod.spec.restartPolicy
```

### CRD (Custom Resource Definition)

- 쿠버네티스 API를 확장하는 방법
- CRD를 설치하면 `kubectl get <custom-resource>` 형태로 사용 가능
- 예: `kubectl get gateway`, `kubectl get httproute` (Gateway API CRD 설치 후)
