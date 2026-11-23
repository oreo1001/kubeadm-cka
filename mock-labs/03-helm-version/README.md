# Mock 03 - Helm (버전 지정 설치 → 값 변경 업그레이드 → 롤백)

## 시험 문제

1. 저장소 `https://stefanprodan.github.io/podinfo`를 이름 `podinfo`로 추가하시오.
2. `helm-lab` namespace(없으면 생성)에 릴리스 `web`을 설치하시오.
   - 차트: `podinfo/podinfo`, **최신보다 한 단계 낮은 버전**
   - `replicaCount=2`, Service 타입 `NodePort`
3. `web`을 **최신 버전**으로 업그레이드하면서 `replicaCount=3`으로 바꾸시오. Service 타입은 유지한다.
4. 업그레이드에 문제가 있다고 가정하고 **처음 설치한 리비전**으로 롤백하시오.
5. 현재 릴리스에 적용된 사용자 지정 값을 `/tmp/web-values.yaml`에 저장하시오.

> 목표 시간: 6분

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
