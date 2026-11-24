# 사전 준비

> ⚠️ 클러스터를 일부러 망가뜨린다. A100 kind에서는 못 고쳐도 [삭제](../cleanup/) 또는 `env-reset`으로 되돌릴 수 있다. 회사 클러스터에서는 절대 하지 않는다.

A100 kind: 사이트 버튼(`setup/run.sh`)이 아래를 대신한다. 손으로 할 때 노드 접속: `docker exec -it cka-control-plane bash` (root라 `sudo` 불필요)

```bash
# master 노드에서
sudo bash break.sh
kubectl create deployment cp-test --image=nginx:alpine --replicas=3
```

원본은 `/root/cka-backup/mock04/`에 저장된다. 풀다 막히면 [삭제](../cleanup/)로 되돌린다.
**`break.sh`와 `run.sh` 내용은 풀기 전에 보지 않는다.**
