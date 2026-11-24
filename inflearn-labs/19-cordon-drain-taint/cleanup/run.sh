#!/usr/bin/env bash
set -euo pipefail
# 정리: worker-2(cka-worker2) env taint 제거·uncordon, maintenance-pod·drain-test 삭제

NODE=cka-worker2
if [ -n "$(kubectl get node "$NODE" -o jsonpath='{.spec.taints[?(@.key=="env")].key}')" ]; then
  kubectl taint node "$NODE" env-
fi
kubectl uncordon "$NODE"
kubectl delete -f ../solution/solution.yaml --ignore-not-found
kubectl delete -f ../setup/setup.yaml --ignore-not-found
