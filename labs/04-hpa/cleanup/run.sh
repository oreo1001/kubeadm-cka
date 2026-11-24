#!/usr/bin/env bash
# Lab 04 정리: HPA와 php-apache 삭제 (metrics-server는 환경 기본 구성이라 남김)
set -euo pipefail
kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete pod load-test --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
