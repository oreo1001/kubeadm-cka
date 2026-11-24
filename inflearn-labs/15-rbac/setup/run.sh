#!/usr/bin/env bash
set -euo pipefail
# 준비: dev namespace와 ci-bot ServiceAccount 생성

kubectl apply -f setup.yaml
kubectl auth can-i get pods -n dev --as=system:serviceaccount:dev:ci-bot || true   # no (아직 권한 없음)
