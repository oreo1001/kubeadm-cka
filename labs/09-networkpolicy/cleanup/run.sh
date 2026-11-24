#!/usr/bin/env bash
# Lab 09 정리: production namespace(NetworkPolicy, Pod, Service) 삭제
set -euo pipefail
kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete namespace production --ignore-not-found
