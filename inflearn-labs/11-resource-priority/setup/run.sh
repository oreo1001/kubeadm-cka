#!/usr/bin/env bash
set -euo pipefail
# 준비: team-a namespace 생성

kubectl create namespace team-a --dry-run=client -o yaml | kubectl apply -f -
