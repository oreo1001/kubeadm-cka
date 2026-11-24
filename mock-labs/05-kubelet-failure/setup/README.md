# 사전 준비

> ⚠️ 노드를 일부러 망가뜨린다. A100 kind에서는 못 고쳐도 [삭제](../cleanup/) 또는 `env-reset`으로 되돌릴 수 있다.

A100 kind: 사이트 버튼(`setup/run.sh`)이 아래를 대신한다. 문제의 `worker-1` = kind 노드 `cka-worker`.
노드 접속: `docker exec -it cka-worker bash` (root라 `sudo` 불필요)

```bash
# worker-1에서
sudo bash break.sh
# kubectl 쓰는 곳에서 1~2분 뒤
kubectl get nodes     # worker-1(cka-worker) NotReady
```

**`break.sh`와 `run.sh` 내용은 풀기 전에 보지 않는다.**
