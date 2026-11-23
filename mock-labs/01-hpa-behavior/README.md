# Mock 01 - HPA (메모리 지표 + scaleDown behavior)

## 시험 문제

`autoscale` namespace에 `api` Deployment가 있다. 다음 HPA를 만드시오.

- HPA 이름: `api-hpa`, 대상: `api` Deployment
- replica: 최소 `2`, 최대 `8`
- 지표 2개
  - CPU 평균 사용률 `60%`
  - 메모리 Pod당 평균 `100Mi`
- 축소(scaleDown) 동작
  - 안정화 창 `60초`
  - `30초`마다 Pod를 최대 `1개`씩만 줄인다

> `kubectl autoscale`만으로는 메모리 지표와 behavior를 넣을 수 없다. YAML을 써야 한다.
> 목표 시간: 6분

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
