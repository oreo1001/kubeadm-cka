# 사전 준비

A100 kind: `setup/run.sh`가 아래를 모두 한다.

## Gateway API CRD 설치

A100 kind 환경에는 env-up 때 이미 설치돼 있다(v1.3.0). 직접 구성할 때만:

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml
```

## NGINX Gateway Fabric 설치

Gateway API v1.3.0과 맞는 NGF 2.2.x를 쓴다. kind에는 LoadBalancer가 없어서 NodePort 배포판을 쓴다.

```bash
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.2.2/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.2.2/deploy/nodeport/deploy.yaml
kubectl get gatewayclass nginx
```

## TLS 인증서 생성 (자체 서명)

```bash
kubectl create namespace web

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key \
  -out /tmp/tls.crt \
  -subj "/CN=example.local/O=example"

kubectl create secret tls web-tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key \
  -n web
```

## 기존 Ingress 기반 앱 배포

```bash
kubectl apply -f setup.yaml
```
