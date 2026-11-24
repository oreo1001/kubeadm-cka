#!/usr/bin/env bash
# Lab 10 정리: local-storage StorageClass 삭제
set -euo pipefail
kubectl delete storageclass local-storage --ignore-not-found
