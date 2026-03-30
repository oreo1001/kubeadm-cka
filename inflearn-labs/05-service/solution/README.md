# 풀이

## 풀이 명령어

```bash
# 방법 1: 명령형
kubectl expose deployment backend \
  --name=backend-svc \
  --port=80 \
  --target-port=8080

kubectl expose deployment backend \
  --name=backend-nodeport \
  --type=NodePort \
  --port=80 \
  --target-port=8080

# nodePort 지정은 명령형 불가 → YAML 수정 필요
kubectl edit svc backend-nodeport  # nodePort: 30080 추가

# 방법 2: YAML 적용
kubectl apply -f solution.yaml

# 확인
kubectl get svc
kubectl describe svc backend-svc
kubectl describe svc backend-nodeport

# ClusterIP 접근 테스트
kubectl run test --image=busybox --rm -it -- wget -qO- http://backend-svc

# NodePort 접근 테스트
curl http://192.168.56.11:30080
```

## 핵심 개념

| Service 타입 | 접근 범위 | 용도 |
|-------------|----------|------|
| `ClusterIP` | 클러스터 내부 | Pod 간 통신 (기본값) |
| `NodePort` | 노드 IP:포트 | 외부 노출 (개발/테스트) |
| `LoadBalancer` | 외부 LB IP | 클라우드 환경 외부 노출 |
| `ExternalName` | DNS CNAME | 외부 서비스 추상화 |

- Service는 selector로 매칭된 Pod들에게 자동으로 트래픽 분산 (Round Robin)
- NodePort 범위: `30000-32767`
- `port`: Service가 수신하는 포트 / `targetPort`: Pod가 실제 사용하는 포트
