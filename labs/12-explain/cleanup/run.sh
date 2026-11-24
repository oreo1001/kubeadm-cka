#!/usr/bin/env bash
# Lab 12 정리: explain 결과 파일 삭제 (호스트와 master 노드 양쪽)
set -euo pipefail
FILES="/tmp/liveness-explain.txt /tmp/liveness-explain-recursive.txt /tmp/strategy-explain.txt /tmp/pvc-accessmodes.txt"
rm -f $FILES
node_exec master "rm -f $FILES"
