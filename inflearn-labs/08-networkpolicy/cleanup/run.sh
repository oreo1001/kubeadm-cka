#!/usr/bin/env bash
set -euo pipefail
# 정리: allow-frontend-to-backend NetworkPolicy와 production namespace 삭제

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
kubectl delete namespace production --ignore-not-found
