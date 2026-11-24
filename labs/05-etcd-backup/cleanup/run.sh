#!/usr/bin/env bash
# Lab 05 정리: etcd.yaml을 /var/lib/etcd로 되돌리고 백업·복원 파일 삭제
set -euo pipefail
MAN=/etc/kubernetes/manifests/etcd.yaml
BK=/root/cka-backup/lab05

if node_exec master "grep -q /var/lib/etcd-restore $MAN"; then
  log "etcd.yaml 원복"
  if node_exec master "[ -f $BK/etcd.yaml ]"; then
    node_exec master "cp $BK/etcd.yaml $MAN"
  else
    node_exec master "sed -i 's#/var/lib/etcd-restore#/var/lib/etcd#g' $MAN"
  fi
  log "etcd · API 서버 재시작 대기"
  sleep 20
  for _ in $(seq 60); do
    if kubectl get --raw=/readyz >/dev/null 2>&1; then break; fi
    sleep 5
  done
  kubectl get --raw=/readyz >/dev/null
fi
node_exec master "rm -f /opt/etcd-backup.db && rm -rf /var/lib/etcd-restore"
