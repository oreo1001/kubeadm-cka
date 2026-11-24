#!/usr/bin/env bash
set -euo pipefail
# 준비: ingress-nginx(kind용 매니페스트, IngressClass nginx) 설치, web namespace에 frontend/api 배포

INGRESS_NGINX_VERSION="${INGRESS_NGINX_VERSION:-controller-v1.15.1}"
log "ingress-nginx $INGRESS_NGINX_VERSION 설치 (kind용)"
kubectl apply -f "https://raw.githubusercontent.com/kubernetes/ingress-nginx/$INGRESS_NGINX_VERSION/deploy/static/provider/kind/deploy.yaml"
kubectl -n ingress-nginx rollout status deployment/ingress-nginx-controller --timeout=300s
kubectl -n ingress-nginx wait --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller --timeout=180s

kubectl apply -f setup.yaml
kubectl -n web rollout status deployment/frontend --timeout=180s
kubectl -n web rollout status deployment/api --timeout=180s
