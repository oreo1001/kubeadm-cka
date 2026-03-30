# 풀이

## 풀이 명령어

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

## 핵심 개념

- HPA는 CPU/Memory 메트릭 기반으로 replica 수를 자동 조정
- `metrics-server`가 클러스터에 설치되어 있어야 함
- `resources.requests.cpu`가 Pod에 정의되어 있어야 CPU 메트릭 수집 가능
- `autoscaling/v2` API 사용 (v1은 deprecated)
