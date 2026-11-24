#!/usr/bin/env bash
set -euo pipefail
# 준비: NGINX Gateway Fabric(GatewayClass nginx, NodePort) 설치, web namespace에 TLS Secret·web-app·기존 Ingress 배포

# Gateway API CRD(standard)는 env-up 때 이미 설치돼 있다
NGF_VERSION="${NGF_VERSION:-v2.8.1}"
log "NGINX Gateway Fabric $NGF_VERSION 설치"
kubectl apply --server-side -f "https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/$NGF_VERSION/deploy/crds.yaml"
kubectl apply -f "https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/$NGF_VERSION/deploy/nodeport/deploy.yaml"
kubectl -n nginx-gateway rollout status deployment/nginx-gateway --timeout=300s

log "자체 서명 TLS 인증서(example.local) → web-tls-secret"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$tmp/tls.key" -out "$tmp/tls.crt" \
  -subj "/CN=example.local/O=example" 2>/dev/null
kubectl create namespace web --dry-run=client -o yaml | kubectl apply -f -
kubectl -n web create secret tls web-tls-secret \
  --cert="$tmp/tls.crt" --key="$tmp/tls.key" --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f setup.yaml
kubectl -n web rollout status deployment/web-app --timeout=180s
