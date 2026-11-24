#!/usr/bin/env bash
# Lab 12 준비: 미리 만들 리소스 없음 (이전 결과 파일이 남아 있으면 호스트·master 노드에서 지움)
set -euo pipefail
FILES="/tmp/liveness-explain.txt /tmp/liveness-explain-recursive.txt /tmp/strategy-explain.txt /tmp/pvc-accessmodes.txt"
rm -f $FILES
node_exec master "rm -f $FILES"
log "준비 완료: kubectl explain 결과를 /tmp/*.txt 에 저장하세요"
