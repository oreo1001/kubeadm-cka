#!/usr/bin/env bash
set -euo pipefail
# 정리: 풀이로 만든 /tmp 결과 파일 삭제

rm -f /tmp/networking-resources.txt /tmp/ingress-rules.txt \
      /tmp/netpol-ingress.txt /tmp/hpa-spec.txt
