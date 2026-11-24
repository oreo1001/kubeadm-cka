#!/usr/bin/env bash
# CKA 실습 환경 조작 (A100, kind). 실행기(agent.py)와 사람이 같은 명령을 쓴다.
#
#   runner/lab.sh env-up                 클러스터가 없으면 만들고, 멈춰 있으면 켠다
#   runner/lab.sh env-reset              클러스터를 지우고 새로 만든다 (깨끗한 상태)
#   runner/lab.sh env-down               노드 컨테이너를 멈춘다 (자원 거의 0)
#   runner/lab.sh lab-setup  <labId>     실습 준비: <폴더>/setup/run.sh
#   runner/lab.sh lab-cleanup <labId>    실습 정리: <폴더>/cleanup/run.sh
#   runner/lab.sh status                 상태 출력 (off | ready)
#
# labId 예: labs-05-etcd-backup, inflearn-08-networkpolicy, mock-04-controlplane-failure
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLUSTER=cka
export KUBECONFIG="${KUBECONFIG_CKA:-$HOME/.kube/cka-kind}"
export PATH="$HOME/.local/bin:$PATH"
CALICO_VERSION="${CALICO_VERSION:-v3.30.3}"
GATEWAY_API_VERSION="${GATEWAY_API_VERSION:-v1.3.0}"
METRICS_SERVER_VERSION="${METRICS_SERVER_VERSION:-v0.9.1}"
NODES=("$CLUSTER-control-plane" "$CLUSTER-worker" "$CLUSTER-worker2")

log() { echo "[lab] $*"; }
die() { echo "[lab] 오류: $*" >&2; exit 1; }

# 문제의 노드 이름 → kind 노드 컨테이너
node_name() {
  case "$1" in
    master|controlplane|control-plane|"$CLUSTER-control-plane") echo "$CLUSTER-control-plane" ;;
    worker-1|node01|worker1|"$CLUSTER-worker") echo "$CLUSTER-worker" ;;
    worker-2|node02|worker2|"$CLUSTER-worker2") echo "$CLUSTER-worker2" ;;
    *) die "모르는 노드 이름: $1" ;;
  esac
}
# 노드 안에서 명령 실행: node_exec master "systemctl stop kubelet"
node_exec() { local n; n="$(node_name "$1")"; shift; docker exec "$n" bash -c "$*"; }
# 노드에 파일 넣기: node_put master ./local.yaml /etc/kubernetes/manifests/x.yaml
node_put() { local n; n="$(node_name "$1")"; docker cp "$2" "$n:$3"; }
export -f node_name node_exec node_put log die
export CLUSTER

exists() { kind get clusters 2>/dev/null | grep -qx "$CLUSTER"; }
# 노드 3개가 모두 돌고 있어야 켜진 것으로 본다
running() {
  local n
  for n in "${NODES[@]}"; do
    [ "$(docker inspect -f '{{.State.Running}}' "$n" 2>/dev/null)" = "true" ] || return 1
  done
}

wait_api() {
  # 멈췄다 켠 직후에는 apiserver가 RBAC을 다 불러오기 전이라 Forbidden이 잠깐 나온다
  for _ in $(seq 1 90); do
    kubectl get --raw /readyz >/dev/null 2>&1 && kubectl get nodes >/dev/null 2>&1 && return 0
    sleep 2
  done
  die "apiserver가 3분 안에 준비되지 않았어요"
}

wait_ready() {
  wait_api
  log "노드 Ready 대기"
  kubectl wait --for=condition=Ready nodes --all --timeout=300s
  # rollout 중 삭제되는 이전 Pod까지 kubectl wait --all로 기다리면 영원히 Ready가 되지 않는다.
  # 컨트롤러의 현재 세대를 확인하고, 컨트롤러가 없는 static control-plane Pod만 직접 기다린다.
  local controller
  while IFS= read -r controller; do
    kubectl -n kube-system rollout status "$controller" --timeout=240s
  done < <(kubectl -n kube-system get deployments,daemonsets -o name)
  kubectl -n kube-system wait --for=condition=Ready pods -l tier=control-plane --timeout=180s >/dev/null
}

# 만들다 실패하면(예: Calico 다운로드) 반쯤 된 클러스터를 지워서 다음 env-up이 처음부터 다시 만들게 한다
CREATING=0
on_exit() {
  local code=$?
  if [ "$CREATING" = 1 ] && [ "$code" != 0 ]; then
    echo "[lab] 생성 실패 — 반쯤 만든 클러스터를 지워요" >&2
    kind delete cluster --name "$CLUSTER" --kubeconfig "$KUBECONFIG" >/dev/null 2>&1 || true
  fi
}
trap on_exit EXIT

create() {
  CREATING=1
  log "클러스터 생성 (kind, 노드 3개)"
  mkdir -p "$(dirname "$KUBECONFIG")"
  kind create cluster --config "$ROOT/runner/kind.yaml" --kubeconfig "$KUBECONFIG" --wait 0s
  log "Calico $CALICO_VERSION 설치"
  # 매니페스트 기본 풀(192.168.0.0/16) 대신 kind.yaml의 podSubnet과 같은 대역을 쓰게 한다
  curl -fsSL "https://raw.githubusercontent.com/projectcalico/calico/$CALICO_VERSION/manifests/calico.yaml"     | sed -e 's|# - name: CALICO_IPV4POOL_CIDR|- name: CALICO_IPV4POOL_CIDR|'           -e 's|#   value: "192.168.0.0/16"|  value: "10.244.0.0/16"|'     | kubectl apply -f - >/dev/null
  kubectl -n kube-system rollout status ds/calico-node --timeout=300s
  wait_ready
  log "metrics-server 설치 (kind라서 --kubelet-insecure-tls)"
  kubectl apply -f "https://github.com/kubernetes-sigs/metrics-server/releases/download/$METRICS_SERVER_VERSION/components.yaml" >/dev/null
  kubectl -n kube-system patch deploy metrics-server --type=json \
    -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]' >/dev/null
  log "Gateway API CRD $GATEWAY_API_VERSION 설치"
  kubectl apply -f "https://github.com/kubernetes-sigs/gateway-api/releases/download/$GATEWAY_API_VERSION/standard-install.yaml" >/dev/null
  wait_ready
  CREATING=0
  log "준비 완료"
}

env_up() {
  if ! exists; then create; return; fi
  if ! running; then
    log "멈춘 노드 시작"
    docker start "${NODES[@]}" >/dev/null   # 이미 돌고 있는 노드는 그대로
  fi
  wait_ready
  log "준비 완료"
}

env_reset() {
  if exists; then log "클러스터 삭제"; kind delete cluster --name "$CLUSTER" --kubeconfig "$KUBECONFIG"; fi
  create
}

env_down() {
  if exists && running; then log "노드 정지"; docker stop "${NODES[@]}" >/dev/null; fi
  log "꺼짐"
}

lab_dir() {
  local id="$1" set name
  [[ "$id" =~ ^(labs|inflearn|mock)-([0-9][0-9]-[a-z0-9-]+)$ ]] || die "labId 형식이 아니에요: $id"
  set="${BASH_REMATCH[1]}"; name="${BASH_REMATCH[2]}"
  case "$set" in labs) set=labs ;; inflearn) set=inflearn-labs ;; mock) set=mock-labs ;; esac
  [ -d "$ROOT/$set/$name" ] || die "없는 실습: $id"
  echo "$ROOT/$set/$name"
}

run_lab() {
  local phase="$1" id="$2" dir script
  dir="$(lab_dir "$id")"
  script="$dir/$phase/run.sh"
  [ -f "$script" ] || die "$id 에는 $phase/run.sh 가 없어요 (A100 kind 미지원 실습일 수 있어요)"
  running || die "클러스터가 꺼져 있어요. env-up 먼저"
  log "$id $phase 시작"
  ( cd "$dir/$phase" && LAB_DIR="$dir" bash "$script" )
  log "$id $phase 완료"
}

# 한 번에 하나만 (실행기·사람·test-all.sh가 겹치지 않게). status는 잠그지 않는다.
if [ "${1:-}" != status ] && [ -n "${1:-}" ]; then
  mkdir -p "$HOME/.cache"
  exec 9>"$HOME/.cache/cka-lab.lock"
  flock -w 1200 9 || die "다른 작업이 20분 넘게 진행 중이에요"
fi

case "${1:-}" in
  env-up) env_up ;;
  env-reset) env_reset ;;
  env-down) env_down ;;
  lab-setup) [ -n "${2:-}" ] || die "labId가 필요해요"; run_lab setup "$2" ;;
  lab-cleanup) [ -n "${2:-}" ] || die "labId가 필요해요"; run_lab cleanup "$2" ;;
  status) if exists && running; then echo ready; else echo off; fi ;;
  *) sed -n '2,13p' "$0"; exit 2 ;;
esac
