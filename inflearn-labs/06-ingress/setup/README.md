# 사전 준비

## nginx Ingress Controller 설치

`setup/run.sh`가 kind용 매니페스트로 설치한다(IngressClass `nginx`).

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.15.1/deploy/static/provider/kind/deploy.yaml

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s
```

## 테스트용 서비스 배포

```bash
kubectl apply -f setup.yaml
```
