# 삭제

```bash
sudo rm -f /opt/etcd-backup.db
sudo rm -rf /var/lib/etcd-restore
```

etcd manifest를 원래대로 되돌리기:

```bash
sudo vi /etc/kubernetes/manifests/etcd.yaml
# volumes.hostPath.path를 /var/lib/etcd-restore → /var/lib/etcd 로 변경
```
