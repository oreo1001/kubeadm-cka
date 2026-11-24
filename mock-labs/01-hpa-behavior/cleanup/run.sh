#!/usr/bin/env bash
# Mock 01 정리: autoscale namespace(api, api-hpa) 삭제
set -euo pipefail
kubectl delete namespace autoscale --ignore-not-found
