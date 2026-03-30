# 사전 준비

## Gateway API CRD 설치

```bash
kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
```

## NGINX Gateway Fabric 설치

```bash
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/crds.yaml
kubectl apply -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/default/deploy.yaml
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
