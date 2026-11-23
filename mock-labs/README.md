# mock-labs: 모의시험 유형 실습

KodeKloud 모의시험 3회분에서 반복된 유형을 이 클러스터용으로 **새로 만든** 문제다(강의 문제를 옮긴 것이 아니다).
`labs/`, `inflearn-labs/`의 기본 문제를 먼저 풀고, 한 단계 어려운 변형으로 넘어온다.

| No | 주제 | 기본 문제 | 목표 시간 | 위험 |
|----|------|-----------|-----------|------|
| 01 | [HPA 메모리 지표 + scaleDown behavior](01-hpa-behavior/) | inflearn-labs/02 | 6분 | |
| 02 | [Gateway API 카나리(가중치 + 헤더)](02-gateway-canary/) | inflearn-labs/07 | 7분 | |
| 03 | [Helm 버전 지정 설치 → 업그레이드 → 롤백](03-helm-version/) | inflearn-labs/12 | 6분 | |
| 04 | [Control plane 장애 2건](04-controlplane-failure/) | inflearn-labs/09 | 8분 | ⚠️ 스냅샷 먼저 |
| 05 | [kubelet 설정 장애 2건](05-kubelet-failure/) | inflearn-labs/17 | 8분 | ⚠️ 스냅샷 먼저 |
| 06 | [Native sidecar](06-native-sidecar/) | inflearn-labs/10 | 5분 | |

## 푸는 순서

1. `setup/`을 적용한다. ⚠️ 표시가 있는 문제는 VM 스냅샷부터 뜬다.
2. **`solution/`을 보지 않고** 타이머를 켜고 푼다. 참고는 kubernetes.io 문서만 쓴다.
3. `solution/`과 비교한다.
4. `cleanup/`으로 정리한다.
5. 틀렸거나 목표 시간을 넘겼으면 `study/오답노트.md`에 적는다(로컬 전용).
