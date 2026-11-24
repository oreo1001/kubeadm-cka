#!/usr/bin/env bash
# Lab 01 정리: high-priority PriorityClass와 critical-nginx Pod 삭제
set -euo pipefail
kubectl delete -f ../solution/solution.yaml --ignore-not-found
