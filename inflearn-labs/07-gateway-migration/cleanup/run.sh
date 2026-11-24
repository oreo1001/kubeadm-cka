#!/usr/bin/env bash
set -euo pipefail
# 정리: web-gateway·HTTPRoute·web-app·Ingress·web-tls-secret과 web namespace 삭제 (NGINX Gateway Fabric은 둔다)

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
kubectl delete secret web-tls-secret -n web --ignore-not-found
kubectl delete namespace web --ignore-not-found
