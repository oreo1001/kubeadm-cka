# Lab 16 - Cluster Upgrade (kubeadm)

## 시험 문제

현재 클러스터의 control plane을 `v1.31.x` → `v1.32.x`로 업그레이드하시오.

요구사항:
1. control plane(master) 노드를 먼저 업그레이드한다
2. worker 노드 1개(worker-1)를 이후 업그레이드한다
3. 업그레이드 중 워크로드 중단을 최소화하기 위해 drain/uncordon을 사용한다

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
