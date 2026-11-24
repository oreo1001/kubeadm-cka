#!/usr/bin/env bash
set -euo pipefail
# 준비: production namespace에 backend(role=backend)·frontend·blocked-pod Pod와 backend Service 배포

kubectl apply -f setup.yaml
kubectl -n production wait --for=condition=ready pod/backend pod/frontend pod/blocked-pod --timeout=180s
kubectl get pods -n production --show-labels
