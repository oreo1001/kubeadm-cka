#!/usr/bin/env bash
set -euo pipefail
# 정리: LimitRange·ResourceQuota·critical-priority PriorityClass·critical-pod와 team-a namespace 삭제

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete namespace team-a --ignore-not-found
