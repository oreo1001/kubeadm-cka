#!/usr/bin/env bash
# Lab 06 준비: 미리 만들 리소스 없음 (이전 풀이의 web namespace가 남아 있으면 지움)
set -euo pipefail
kubectl delete namespace web --ignore-not-found
log "준비 완료: web namespace에 web-app Deployment와 web-app-svc(NodePort 30080)를 만드세요"
