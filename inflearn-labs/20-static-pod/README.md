# Lab 20 - Static Pod

## 시험 문제

`master` 노드에 다음 조건으로 Static Pod를 생성하시오.

- Pod 이름: `static-web`
- image: `nginx:alpine`
- containerPort: `80`
- Static Pod manifest 경로: `/etc/kubernetes/manifests/`

생성 후 `kubectl get pod`로 `static-web-master` Pod가 Running 상태인지 확인하시오.

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
