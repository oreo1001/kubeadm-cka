# 사전 준비

> ⚠️ 클러스터를 일부러 망가뜨린다. A100 VM에서 **스냅샷을 뜬 뒤** 한다. 회사 클러스터에서는 절대 하지 않는다.

```bash
# master 노드에서
sudo bash break.sh
kubectl create deployment cp-test --image=nginx:alpine --replicas=3
```

원본은 `/root/cka-backup/mock04/`에 저장된다. 풀다 막히면 [삭제](../cleanup/)로 되돌린다.
**`break.sh` 내용은 풀기 전에 보지 않는다.**
