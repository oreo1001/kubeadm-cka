#!/usr/bin/env bash
# Mock 04 준비: master의 scheduler · controller-manager manifest를 고장 내고 cp-test Deployment 생성 (break.sh 내용)
# ⚠️ 풀기 전에 이 파일을 보지 않는다.
set -euo pipefail

BREAK=$(cat <<'SH'
set -euo pipefail
MAN=/etc/kubernetes/manifests
BK=/root/cka-backup/mock04
mkdir -p "$BK"
for f in kube-scheduler.yaml kube-controller-manager.yaml; do
  [ -f "$BK/$f" ] || cp "$MAN/$f" "$BK/"
done
# 1) scheduler 실행 명령 오타
sed -i 's/^\(\s*- \)kube-scheduler$/\1kube-schedulerr/' "$MAN/kube-scheduler.yaml"
# 2) controller-manager kubeconfig 경로 오타 (--authentication-kubeconfig 등은 건드리지 않음)
sed -i 's#--kubeconfig=/etc/kubernetes/controller-manager.conf#--kubeconfig=/etc/kubernetes/controller-manager.config#' \
  "$MAN/kube-controller-manager.yaml"
echo "고장 주입 완료. 원본: $BK"
SH
)

kubectl delete deployment cp-test --ignore-not-found
# kind 노드 이미지에는 편집기가 없을 수 있다 (manifest 수정용)
node_exec master "command -v vi >/dev/null || { apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -y -qq vim-tiny >/dev/null; }"
node_exec master "$BREAK"

log "scheduler · controller-manager 컨테이너가 내려갈 때까지 대기"
down=""
for _ in $(seq 30); do
  if [ -z "$(node_exec master "crictl ps -q --name 'kube-scheduler|kube-controller-manager'")" ]; then down=1; break; fi
  sleep 5
done
[ -n "$down" ] || log "경고: 아직 떠 있는 컨테이너가 있어요 (kubelet 반영 지연)"

kubectl create deployment cp-test --image=nginx:alpine --replicas=3
log "준비 완료: cp-test Pod 3개가 Running이 되게 고치세요"
