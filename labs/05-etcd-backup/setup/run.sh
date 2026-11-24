#!/usr/bin/env bash
# Lab 05 준비: master 노드에 etcd와 같은 버전의 etcdctl·etcdutl을 넣고 etcd.yaml 원본을 백업
set -euo pipefail
BK=/root/cka-backup/lab05
node_exec master "mkdir -p $BK && { [ -f $BK/etcd.yaml ] || cp /etc/kubernetes/manifests/etcd.yaml $BK/; }"

if node_exec master "command -v etcdctl >/dev/null && command -v etcdutl >/dev/null"; then
  log "etcdctl·etcdutl 이미 있음"
else
  image="$(kubectl -n kube-system get pod -l component=etcd -o jsonpath='{.items[0].spec.containers[0].image}')"
  tag="${image##*:}"
  ver="v${tag%%-*}"   # registry.k8s.io/etcd:3.6.5-0 -> v3.6.5
  case "$(uname -m)" in
    x86_64) arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) die "모르는 아키텍처: $(uname -m)" ;;
  esac
  log "etcd $ver 클라이언트(etcdctl, etcdutl) 설치"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  pkg="etcd-$ver-linux-$arch"
  curl -fsSL "https://github.com/etcd-io/etcd/releases/download/$ver/$pkg.tar.gz" \
    | tar -xz -C "$tmp" --strip-components=1 "$pkg/etcdctl" "$pkg/etcdutl"
  node_put master "$tmp/etcdctl" /usr/local/bin/etcdctl
  node_put master "$tmp/etcdutl" /usr/local/bin/etcdutl
  node_exec master "chmod +x /usr/local/bin/etcdctl /usr/local/bin/etcdutl"
fi
node_exec master "etcdctl version && etcdutl version"
# kind 노드 이미지에는 편집기가 없을 수 있다 (etcd.yaml 수정용)
node_exec master "command -v vi >/dev/null || { apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq vim-tiny >/dev/null; }"
log "준비 완료: docker exec -it cka-control-plane bash 로 들어가 백업/복원하세요"
