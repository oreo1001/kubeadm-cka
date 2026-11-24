#!/usr/bin/env bash
# Lab 06 정리: web namespace(web-app, web-app-svc) 삭제
set -euo pipefail
kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete namespace web --ignore-not-found
