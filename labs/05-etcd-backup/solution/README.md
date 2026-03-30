# 풀이

## Task A: 백업

```bash
# etcd 인증서 경로 확인
ls /etc/kubernetes/pki/etcd/

# 스냅샷 저장
ETCDCTL_API=3 etcdctl snapshot save /opt/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# 백업 검증
ETCDCTL_API=3 etcdctl snapshot status /opt/etcd-backup.db \
  --write-out=table
```

## Task B: 복원

```bash
# 1. 스냅샷 복원 (새 데이터 디렉토리로)
ETCDCTL_API=3 etcdctl snapshot restore /opt/etcd-backup.db \
  --data-dir=/var/lib/etcd-restore

# 2. etcd static pod 매니페스트 수정
sudo vi /etc/kubernetes/manifests/etcd.yaml
# volumes.hostPath.path를 /var/lib/etcd → /var/lib/etcd-restore 로 변경

# 3. etcd Pod 재시작 대기 (매니페스트 변경 시 자동 재시작)
watch kubectl get pods -n kube-system

# 4. 클러스터 정상 동작 확인
kubectl get nodes
kubectl get pods -A
```

## etcd.yaml 수정 내용

```yaml
volumes:
  - hostPath:
      path: /var/lib/etcd-restore  # 기존: /var/lib/etcd
      type: DirectoryOrCreate
    name: etcd-data
```

## 핵심 개념

- kubeadm 클러스터에서 etcd는 static pod로 실행됨
- static pod 매니페스트 위치: `/etc/kubernetes/manifests/`
- etcd 인증서 위치: `/etc/kubernetes/pki/etcd/`
- 백업은 스냅샷, 복원은 새 데이터 디렉토리에 수행 후 etcd가 그 디렉토리를 사용하도록 설정
