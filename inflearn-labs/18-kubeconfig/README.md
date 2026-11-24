# Lab 18 - kubeconfig (사용자 컨텍스트 추가)

## 시험 문제

다음 조건으로 `/root/.kube/config`에 새 컨텍스트를 추가하시오.

- user: `dev-user`
- cluster: 현재 클러스터 (`kubernetes`)
- context 이름: `dev-context`
- default namespace: `dev`
- 추가 후 현재 컨텍스트를 `dev-context`로 변경하시오

> A100 kind 환경: `/root/.kube/config`는 master 노드(`cka-control-plane`) 안의 파일이다(`setup/run.sh`가 `admin.conf`로 만들어 둔다). 노드 접속: `docker exec -it cka-control-plane bash` 후 풀이한다. 호스트의 `~/.kube/cka-kind`는 건드리지 않는다.

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
