#!/usr/bin/env bash
set -euo pipefail
# 정리: app-with-sidecar Pod 삭제

kubectl delete pod app-with-sidecar --ignore-not-found
