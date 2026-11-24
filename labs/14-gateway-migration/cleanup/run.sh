#!/usr/bin/env bash
# Lab 14 정리: web namespace(Gateway, HTTPRoute, Ingress, 앱, Secret)와 NGINX Gateway Fabric 삭제
# Gateway API CRD는 환경 기본 구성(env-up)이라 남긴다
set -euo pipefail
NGF_VERSION="${NGF_VERSION:-v2.2.2}"
NGF_URL="https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/$NGF_VERSION/deploy"

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete namespace web --ignore-not-found
kubectl delete -f "$NGF_URL/nodeport/deploy.yaml" --ignore-not-found
kubectl delete -f "$NGF_URL/crds.yaml" --ignore-not-found
