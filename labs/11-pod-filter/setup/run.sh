#!/usr/bin/env bash
# Lab 11 준비: Task B용 app=nginx Pod 2개(default, web-test ns)를 만들고, 이전 결과 파일을 지움(호스트·master 노드)
set -euo pipefail
FILES="/tmp/running-pods.txt /tmp/nginx-pods.txt /tmp/etcd-pods.txt"
rm -f $FILES
node_exec master "rm -f $FILES"
kubectl create namespace web-test --dry-run=client -o yaml | kubectl apply -f -
kubectl run nginx-a --image=nginx:alpine --labels=app=nginx -n default --dry-run=client -o yaml | kubectl apply -f -
kubectl run nginx-b --image=nginx:alpine --labels=app=nginx -n web-test --dry-run=client -o yaml | kubectl apply -f -
log "준비 완료: 결과를 /tmp/*.txt 에 저장하세요"
