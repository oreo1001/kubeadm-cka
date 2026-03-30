# Lab 11 - Pod 필터링 → 파일 저장

## 시험 문제

다음 작업을 수행하시오.

### Task A
`kube-system` namespace에서 `Running` 상태인 Pod의 이름 목록을 `/tmp/running-pods.txt`에 저장하시오. (Pod 이름만, 한 줄에 하나씩)

### Task B
모든 namespace에서 `app=nginx` label을 가진 Pod의 이름과 namespace를 `/tmp/nginx-pods.txt`에 저장하시오.

### Task C
`kube-system` namespace에서 컨테이너 이름에 `etcd`가 포함된 Pod 이름을 `/tmp/etcd-pods.txt`에 저장하시오.

---

- [풀이](solution/)
- [삭제](cleanup/)
