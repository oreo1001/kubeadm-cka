# Mock 06 - Native Sidecar로 로그 수집

## 시험 문제

`sidecar` namespace의 `logger` Deployment는 `/var/log/app/app.log`에 로그를 쓴다.
기존 컨테이너는 그대로 두고 다음을 추가하시오.

- 이름이 `log-tail`인 **사이드카**: 이미지 `busybox:1.36`, 명령 `tail -F /var/log/app/app.log`
- 사이드카는 **native sidecar**(앱 컨테이너보다 먼저 뜨고 Pod 수명 동안 계속 도는 init 컨테이너)로 만든다.
- 두 컨테이너가 `logs`라는 `emptyDir` 볼륨을 `/var/log/app`에 함께 마운트한다.

`kubectl logs deploy/logger -c log-tail -n sidecar`로 로그가 보여야 한다.

> 목표 시간: 5분

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
