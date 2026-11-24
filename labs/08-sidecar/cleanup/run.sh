#!/usr/bin/env bash
# Lab 08 정리: log-pod 삭제
set -euo pipefail
kubectl delete pod log-pod --ignore-not-found
