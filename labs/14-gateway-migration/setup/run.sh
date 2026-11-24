#!/usr/bin/env bash
# Lab 14 준비: NGINX Gateway Fabric(GatewayClass nginx) 설치, web namespace에 TLS Secret과 기존 Ingress 앱 배포
set -euo pipefail
# Gateway API CRD(v1.3.0)는 env-up 때 이미 설치됨 → 이와 호환되는 NGF 2.2.x 사용
NGF_VERSION="${NGF_VERSION:-v2.2.2}"
NGF_URL="https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/$NGF_VERSION/deploy"

log "NGINX Gateway Fabric $NGF_VERSION 설치 (데이터플레인 Service는 NodePort)"
kubectl apply --server-side -f "$NGF_URL/crds.yaml" >/dev/null
kubectl apply -f "$NGF_URL/nodeport/deploy.yaml" >/dev/null
kubectl -n nginx-gateway rollout status deploy/nginx-gateway --timeout=300s

kubectl create namespace web --dry-run=client -o yaml | kubectl apply -f -

log "자체 서명 TLS 인증서 → web-tls-secret"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout "$tmp/tls.key" -out "$tmp/tls.crt" \
  -subj "/CN=example.local/O=example" 2>/dev/null
kubectl create secret tls web-tls-secret --cert="$tmp/tls.crt" --key="$tmp/tls.key" -n web \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl apply -f setup.yaml
kubectl -n web rollout status deploy/web-app --timeout=180s
log "준비 완료: web-ingress를 web-gateway + web-route로 옮기세요"
