# 사전 준비

## Gateway API CRD

A100 kind 환경은 `env-up` 때 Gateway API CRD(standard, v1.3.0)가 이미 설치돼 있다.

## NGINX Gateway Fabric 설치

kind에는 LoadBalancer가 없으므로 NodePort용 매니페스트를 쓴다(GatewayClass `nginx`).

```bash
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.8.1/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.8.1/deploy/nodeport/deploy.yaml
```

## 자체 서명 TLS 인증서 생성

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key \
  -out /tmp/tls.crt \
  -subj "/CN=example.local/O=example"

kubectl create namespace web
kubectl create secret tls web-tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n web
```

## 기존 Ingress 기반 앱 배포

```bash
kubectl apply -f setup.yaml
```
