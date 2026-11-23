# 사전 준비

> ⚠️ 노드를 일부러 망가뜨린다. A100 VM에서 **스냅샷을 뜬 뒤** 한다.

```bash
# worker-1에서
sudo bash break.sh
# master에서 1~2분 뒤
kubectl get nodes     # worker-1 NotReady
```

**`break.sh` 내용은 풀기 전에 보지 않는다.**
