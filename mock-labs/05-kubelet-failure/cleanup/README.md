# 삭제

못 고쳤을 때 원복 (worker-1에서):

```bash
sudo cp /root/cka-backup/mock05/kubelet.conf /etc/kubernetes/kubelet.conf
sudo cp /root/cka-backup/mock05/config.yaml /var/lib/kubelet/config.yaml
sudo systemctl restart kubelet
```
