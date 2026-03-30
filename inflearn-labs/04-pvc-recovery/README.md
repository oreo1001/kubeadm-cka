# Lab 04 - PVC 복구 및 관리 (Released PV 재사용)

## 시험 문제

`default` namespace에 `Released` 상태의 PV `old-data-pv`가 있다.
기존 PVC가 삭제되어 PV가 `Released` 상태이지만 데이터는 보존되어 있다.

1. `old-data-pv`를 다시 `Available` 상태로 만들기
2. 새 PVC `restored-pvc` 생성 후 해당 PV에 바인딩
   - 용량: `1Gi`, accessMode: `ReadWriteOnce`, storageClassName: `manual`
3. `restored-pvc`를 사용하는 Pod `data-pod` 생성 (image: `nginx:alpine`, mountPath: `/data`)

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
