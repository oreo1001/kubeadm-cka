#!/usr/bin/env bash
# Lab 11 정리: Task B용 Pod와 web-test ns, 결과 파일 삭제 (호스트와 master 노드 양쪽)
set -euo pipefail
FILES="/tmp/running-pods.txt /tmp/nginx-pods.txt /tmp/etcd-pods.txt"
rm -f $FILES
node_exec master "rm -f $FILES"
kubectl delete pod nginx-a -n default --ignore-not-found
kubectl delete namespace web-test --ignore-not-found
