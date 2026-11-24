#!/usr/bin/env bash
set -euo pipefail
# 정리: ci-role Role, ci-rolebinding RoleBinding, ci-bot ServiceAccount와 dev namespace 삭제

kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
