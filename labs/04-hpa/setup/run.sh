#!/usr/bin/env bash
# Lab 04 준비: php-apache Deployment/Service 배포 (metrics-server는 env-up 때 이미 설치됨)
set -euo pipefail
kubectl apply -f setup.yaml
kubectl rollout status deploy/php-apache --timeout=180s
kubectl -n kube-system rollout status deploy/metrics-server --timeout=180s
log "준비 완료: php-apache-hpa HPA를 만드세요 (kubectl top 값은 1~2분 뒤 나옴)"
