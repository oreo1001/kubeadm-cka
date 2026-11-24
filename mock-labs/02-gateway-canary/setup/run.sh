#!/usr/bin/env bash
# Mock 02 준비: NGINX Gateway Fabric(GatewayClass nginx) 설치, shop namespace에 app-v1/v2와 Gateway shop-gw 배포
set -euo pipefail
# Gateway API CRD(v1.3.0)는 env-up 때 이미 설치됨 → 이와 호환되는 NGF 2.2.x 사용
NGF_VERSION="${NGF_VERSION:-v2.2.2}"
NGF_URL="https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/$NGF_VERSION/deploy"

log "NGINX Gateway Fabric $NGF_VERSION 설치 (데이터플레인 Service는 NodePort)"
kubectl apply --server-side -f "$NGF_URL/crds.yaml" >/dev/null
kubectl apply -f "$NGF_URL/nodeport/deploy.yaml" >/dev/null
kubectl -n nginx-gateway rollout status deploy/nginx-gateway --timeout=300s

kubectl apply -f setup.yaml
kubectl -n shop rollout status deploy/app-v1 --timeout=180s
kubectl -n shop rollout status deploy/app-v2 --timeout=180s
kubectl -n shop wait --for=condition=Programmed gateway/shop-gw --timeout=180s
log "준비 완료: shop-route HTTPRoute를 만드세요"
