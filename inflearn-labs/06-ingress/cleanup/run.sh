#!/usr/bin/env bash
set -euo pipefail
# 정리: web-ingress Ingress와 web namespace 삭제 (ingress-nginx 컨트롤러는 다른 실습에서도 쓰므로 둔다)

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
kubectl delete namespace web --ignore-not-found
