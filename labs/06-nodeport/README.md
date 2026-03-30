# Lab 06 - NodePort 서비스 생성

## 시험 문제

`web` namespace에 다음을 생성하시오.

1. Deployment `web-app`
   - replicas: `2`
   - image: `nginx:latest`
   - containerPort: `80`

2. NodePort 서비스 `web-app-svc`
   - port: `80`
   - targetPort: `80`
   - nodePort: `30080`

## 풀이

```bash
# namespace 생성
kubectl create namespace web

# 방법 1: YAML 적용
kubectl apply -f solution.yaml

# 방법 2: 명령형
kubectl create deployment web-app \
  --image=nginx:latest \
  --replicas=2 \
  --namespace=web \
  --port=80

kubectl expose deployment web-app \
  --name=web-app-svc \
  --type=NodePort \
  --port=80 \
  --target-port=80 \
  --namespace=web

# nodePort는 expose 명령으로 직접 지정 불가 → YAML로 수정 필요
kubectl edit svc web-app-svc -n web
# nodePort: 30080 추가

# 확인
kubectl get svc web-app-svc -n web
curl http://192.168.121.10:30080
```

## 삭제

```bash
kubectl delete -f solution.yaml
# 또는
kubectl delete namespace web
```

## 핵심 개념

- NodePort 범위: 30000~32767
- ClusterIP → NodePort → LoadBalancer 순으로 외부 노출 범위 증가
- `kubectl expose`로 서비스 생성 후 `kubectl edit`으로 nodePort 지정 가능
