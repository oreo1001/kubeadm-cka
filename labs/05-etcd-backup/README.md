# Lab 05 - etcd 백업 / 복원

## 시험 문제

### Task A: etcd 스냅샷 백업
`master` 노드에서 etcd 스냅샷을 `/opt/etcd-backup.db`에 저장하시오.

### Task B: etcd 복원
`/opt/etcd-backup.db`에서 etcd를 복원하시오.
복원 데이터 디렉토리: `/var/lib/etcd-restore`
복원 후 etcd static pod가 새 데이터 디렉토리를 사용하도록 설정하시오.

## 사전 준비

```bash
# etcdctl 설치 확인 (kubeadm 클러스터에는 etcd Pod 내에 있음)
kubectl exec -n kube-system etcd-master -- etcdctl version

# 또는 로컬에 설치
sudo apt-get install etcd-client
```

## 풀이

### A. 백업

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

### B. 복원

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

### etcd.yaml 수정 내용

```yaml
# /etc/kubernetes/manifests/etcd.yaml 에서 다음 부분 수정
volumes:
  - hostPath:
      path: /var/lib/etcd-restore  # 기존: /var/lib/etcd
      type: DirectoryOrCreate
    name: etcd-data
```

## 삭제

```bash
# 백업 파일 제거
sudo rm -f /opt/etcd-backup.db

# 복원 디렉토리 제거 후 원래 etcd 디렉토리로 복구
sudo vi /etc/kubernetes/manifests/etcd.yaml
# volumes.hostPath.path를 /var/lib/etcd-restore → /var/lib/etcd 로 되돌리기
sudo rm -rf /var/lib/etcd-restore
```

## 핵심 개념

- kubeadm 클러스터에서 etcd는 static pod로 실행됨
- static pod 매니페스트 위치: `/etc/kubernetes/manifests/`
- etcd 인증서 위치: `/etc/kubernetes/pki/etcd/`
- 백업은 스냅샷, 복원은 새 데이터 디렉토리에 수행 후 etcd가 그 디렉토리를 사용하도록 설정
