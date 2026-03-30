# Lab 05 - etcd 백업 / 복원

## 시험 문제

### Task A: etcd 스냅샷 백업
`master` 노드에서 etcd 스냅샷을 `/opt/etcd-backup.db`에 저장하시오.

### Task B: etcd 복원
`/opt/etcd-backup.db`에서 etcd를 복원하시오.
복원 데이터 디렉토리: `/var/lib/etcd-restore`
복원 후 etcd static pod가 새 데이터 디렉토리를 사용하도록 설정하시오.

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
