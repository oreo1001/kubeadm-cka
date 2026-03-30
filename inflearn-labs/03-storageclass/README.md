# Lab 03 - StorageClass 생성 (동적 프로비저닝)

## 시험 문제

다음 요구사항에 맞는 StorageClass를 생성하시오.

- 이름: `local-storage`
- provisioner: `kubernetes.io/no-provisioner`
- volumeBindingMode: `WaitForFirstConsumer`
- reclaimPolicy: `Retain`

---

- [풀이](solution/)
- [삭제](cleanup/)
