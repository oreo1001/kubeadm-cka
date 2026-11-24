#!/usr/bin/env bash
# 모든 실습의 setup → cleanup을 실제 클러스터에서 돌려 ~/cka-lab/test-all.tsv에 결과를 남긴다(약 20분)
cd ~/cka-lab
export KUBECONFIG=~/.kube/cka-kind PATH=~/.local/bin:$PATH
OUT=~/cka-lab/test-all.tsv
: > "$OUT"
healthy() {
  kubectl wait --for=condition=Ready nodes --all --timeout=120s >/dev/null 2>&1 &&
  [ -z "$(kubectl -n kube-system get pods --no-headers 2>/dev/null | grep -v -E 'Running|Completed')" ]
}
for f in labs/*/setup/run.sh inflearn-labs/*/setup/run.sh mock-labs/*/setup/run.sh; do
  d=$(dirname "$(dirname "$f")"); set=$(dirname "$d"); name=$(basename "$d")
  case "$set" in labs) id="labs-$name" ;; inflearn-labs) id="inflearn-$name" ;; mock-labs) id="mock-$name" ;; esac
  t0=$(date +%s)
  if runner/lab.sh lab-setup "$id" > "/tmp/lab-$id-setup.log" 2>&1; then s=ok; else s=FAIL; fi
  t1=$(date +%s)
  if runner/lab.sh lab-cleanup "$id" > "/tmp/lab-$id-cleanup.log" 2>&1; then c=ok; else c=FAIL; fi
  t2=$(date +%s)
  if healthy; then h=healthy; else h=RESET; runner/lab.sh env-reset > "/tmp/lab-$id-reset.log" 2>&1; fi
  printf '%s\t%s\t%ss\t%s\t%ss\t%s\n' "$id" "$s" $((t1-t0)) "$c" $((t2-t1)) "$h" >> "$OUT"
done
echo ALLDONE >> "$OUT"
