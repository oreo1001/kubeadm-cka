# Lab 05 - Service 생성 (L4 로드밸런싱)

## 시험 문제

`default` namespace에 `label: app=backend` 인 Pod들이 배포되어 있다.
다음 요구사항에 맞는 Service를 생성하시오.

### 요구사항 1: ClusterIP Service
- 이름: `backend-svc`
- selector: `app=backend`
- port: `80`, targetPort: `8080`

### 요구사항 2: NodePort Service
- 이름: `backend-nodeport`
- selector: `app=backend`
- port: `80`, targetPort: `8080`
- nodePort: `30080`

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
