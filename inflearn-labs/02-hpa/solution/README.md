# 풀이

## 풀이 명령어

```bash
# 방법 1: kubectl autoscale (명령형 — 시험 권장)
kubectl autoscale deployment php-apache \
  --name=php-apache-hpa \
  --cpu-percent=50 \
  --min=1 \
  --max=5

# 방법 2: YAML 적용
kubectl apply -f solution.yaml

# 확인
kubectl get hpa php-apache-hpa
kubectl describe hpa php-apache-hpa

# 부하 테스트 (HPA 동작 확인)
kubectl run load-test --image=busybox --rm -it -- \
  /bin/sh -c "while true; do wget -q -O- http://php-apache; done"

# 다른 터미널에서 모니터링
watch kubectl get hpa php-apache-hpa
```

## 핵심 개념

- HPA는 `metrics-server`가 설치되어 있어야 동작
- Pod에 `resources.requests.cpu`가 정의되어야 CPU 메트릭 수집 가능
- `autoscaling/v2` API 사용 (`autoscaling/v1`은 deprecated)

```
부하 증가 → CPU 사용률 > 50% → HPA가 replica 증가 → Pod 스케일 아웃
부하 감소 → CPU 사용률 < 50% → HPA가 replica 감소 → Pod 스케일 인 (5분 쿨다운)
```
