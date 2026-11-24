#!/usr/bin/env bash
set -euo pipefail
# 정리: app-config ConfigMap, web-app Deployment 삭제

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
