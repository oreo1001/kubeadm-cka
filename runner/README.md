# runner — A100 실습 환경 실행기

cka-prep 사이트의 직접 실습 화면 버튼으로 A100의 kind 클러스터를 다룬다.

```
[사이트 버튼] → 작업 큐(Upstash Redis) ← agent.py가 폴링(바깥으로만) → lab.sh → kind/docker
```

## 동작 (이것만 허용)
| 동작 | 하는 일 |
|---|---|
| `env-up` | 클러스터(`cka`, 노드 3개)가 없으면 만들고(Calico · metrics-server · Gateway API CRD), 멈춰 있으면 켠다 |
| `env-reset` | 지우고 새로 만든다(망가뜨린 실습 뒤, 1~2분) |
| `env-down` | 노드 컨테이너를 멈춘다(자원 거의 0). 60분 동안 쓰지 않으면 사이트가 자동으로 넣는다 |
| `lab-setup <labId>` | `<폴더>/setup/run.sh` |
| `lab-cleanup <labId>` | `<폴더>/cleanup/run.sh` |

손으로도 같은 명령을 쓴다: `runner/lab.sh env-up`, `runner/lab.sh lab-setup labs-09-networkpolicy`.

## 노드 이름
문제의 `master` · `worker-1` · `worker-2` = kind 노드 컨테이너 `cka-control-plane` · `cka-worker` · `cka-worker2`.
노드 안으로 들어가기(시험의 `ssh` 대신): `docker exec -it cka-control-plane bash`.
kubeconfig: `export KUBECONFIG=~/.kube/cka-kind`.

## 실습 스크립트 규칙 (`setup/run.sh`, `cleanup/run.sh`)
- `lab.sh`가 실행한다. `KUBECONFIG`, `LAB_DIR`(실습 폴더), 헬퍼 `node_exec <노드> "<명령>"`, `node_put <노드> <로컬파일> <노드경로>`, `log`가 준비돼 있다.
- 같은 폴더의 `setup.yaml` 등은 상대 경로로 쓴다(작업 디렉터리가 그 폴더).
- 다시 실행해도 안전하게(`kubectl apply`, `--ignore-not-found`).
- sudo 없음. 노드 안에서는 root다.
- A100 kind로 못 하는 실습(스크립트 없음): `labs/02-dpkg-install`, `labs/07-cni`, `inflearn-labs/13-cni-cri`, `inflearn-labs/16-cluster-upgrade` → 사이트에서 KodeKloud 랩으로 안내.

## A100 설치
```bash
# kind (사용자 홈, sudo 없음)
mkdir -p ~/.local/bin
curl -Lo ~/.local/bin/kind https://kind.sigs.k8s.io/dl/latest/kind-linux-amd64 && chmod +x ~/.local/bin/kind
# 이 repo
git clone https://github.com/oreo1001/kubeadm-cka.git ~/cka-lab
# 실행기 설정
mkdir -p ~/.config/cka-runner
cat > ~/.config/cka-runner/env <<CFG
SITE_URL=https://<cka-prep 주소>
RUNNER_TOKEN=<사이트 RUNNER_TOKEN과 같은 값>
LAB_DIR=$HOME/cka-lab
CFG
chmod 600 ~/.config/cka-runner/env
```

계속 돌리기: `systemctl --user enable --now cka-runner`(위 service 파일) 또는 tmux:
```bash
tmux new -d -s cka-runner 'python3 ~/cka-lab/runner/agent.py'
```

## 테스트
```bash
cd runner && python3 -m unittest test_agent && bash -n lab.sh
```
