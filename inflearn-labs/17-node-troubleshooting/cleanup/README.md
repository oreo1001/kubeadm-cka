# 삭제

별도 삭제 불필요 — 풀이 과정에서 노드가 이미 정상 복구됩니다.

노드가 여전히 NotReady라면:

```bash
ssh vagrant@192.168.56.11
sudo systemctl start kubelet
sudo systemctl enable kubelet
```
