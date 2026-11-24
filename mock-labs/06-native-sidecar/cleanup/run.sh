#!/usr/bin/env bash
# Mock 06 정리: sidecar namespace(logger) 삭제
set -euo pipefail
kubectl delete namespace sidecar --ignore-not-found
