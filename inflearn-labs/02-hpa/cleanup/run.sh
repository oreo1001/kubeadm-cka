#!/usr/bin/env bash
set -euo pipefail
# 정리: php-apache-hpa HPA와 php-apache Deployment/Service 삭제 (metrics-server는 클러스터 기본이라 둔다)

kubectl delete hpa php-apache-hpa --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
