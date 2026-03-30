# Lab 04 - Deployment에 HPA 생성

## 시험 문제

`default` namespace에 이미 `php-apache` Deployment가 배포되어 있다.
다음 요구사항에 맞는 HPA를 생성하시오.

- HPA 이름: `php-apache-hpa`
- 대상: `php-apache` Deployment
- 최소 replica: `1`
- 최대 replica: `5`
- CPU 사용률 목표: `50%`

## 실습 준비

```bash
# setup.yaml로 php-apache Deployment 먼저 생성
kubectl apply -f setup.yaml

# metrics-server 설치 (HPA에 필요)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# metrics-server TLS 검증 비활성화 (로컬 환경용)
kubectl patch deployment metrics-server \
  -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```

## 풀이

```bash
# 방법 1: kubectl autoscale (명령형)
kubectl autoscale deployment php-apache \
  --name=php-apache-hpa \
  --cpu-percent=50 \
  --min=1 \
  --max=5

# 방법 2: YAML 적용 (선언형)
kubectl apply -f solution.yaml

# 확인
kubectl get hpa php-apache-hpa
kubectl describe hpa php-apache-hpa

# 부하 테스트 (HPA 동작 확인)
kubectl run load-test --image=busybox --rm -it -- \
  /bin/sh -c "while true; do wget -q -O- http://php-apache; done"
```

## 삭제

```bash
kubectl delete -f solution.yaml
kubectl delete -f setup.yaml
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

## 핵심 개념

- HPA는 CPU/Memory 메트릭 기반으로 replica 수를 자동 조정
- `metrics-server`가 클러스터에 설치되어 있어야 함
- `resources.requests.cpu`가 Pod에 정의되어 있어야 CPU 메트릭 수집 가능
- `autoscaling/v2` API 사용 (v1은 deprecated)
