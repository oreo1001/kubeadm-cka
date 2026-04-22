# Lab 19 - Cordon / Drain / Taint

## 시험 문제

다음 작업을 순서대로 수행하시오.

1. `worker-2` 노드를 **cordon** 하여 새 Pod가 스케줄되지 않도록 하시오
2. `worker-2` 노드를 **drain** 하시오 (DaemonSet은 무시, 로컬 스토리지 강제 삭제)
3. `worker-2` 노드에 taint를 추가하시오
   - key: `env`, value: `maintenance`, effect: `NoSchedule`
4. 위 taint를 **toleration**하는 Pod `maintenance-pod`를 생성하시오
   - image: `nginx:alpine`
   - namespace: `default`

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
