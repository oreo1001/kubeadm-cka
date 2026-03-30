# Lab 13 - PV / PVC 생성

## 시험 문제

다음 요구사항에 맞게 PersistentVolume과 PersistentVolumeClaim을 생성하시오.

**PersistentVolume** (`data-pv`):
- capacity: `2Gi`
- accessModes: `ReadWriteOnce`
- reclaimPolicy: `Retain`
- storageClassName: `local-storage`
- hostPath: `/mnt/data`

**PersistentVolumeClaim** (`data-pvc`):
- namespace: `default`
- storage 요청: `1Gi`
- accessModes: `ReadWriteOnce`
- storageClassName: `local-storage`

PVC가 PV에 바인딩되는지 확인하시오.

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
