#!/usr/bin/env bash
set -euo pipefail
# 준비: 없음 (Gateway API CRD는 env-up 때 이미 설치됨). 이전 결과 파일이 남아 있으면 지운다

rm -f /tmp/networking-resources.txt /tmp/ingress-rules.txt /tmp/netpol-ingress.txt /tmp/hpa-spec.txt
log "준비할 리소스 없음 — 바로 문제를 풀면 된다"
