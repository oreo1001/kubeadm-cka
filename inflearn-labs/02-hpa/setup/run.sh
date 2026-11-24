#!/usr/bin/env bash
set -euo pipefail
# 준비: php-apache Deployment/Service 배포, metrics-server(env-up 때 설치됨) 준비 대기

kubectl apply -f setup.yaml
kubectl -n kube-system wait --for=condition=available deployment/metrics-server --timeout=180s
kubectl rollout status deployment/php-apache --timeout=180s
