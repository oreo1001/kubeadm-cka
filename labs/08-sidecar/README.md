# Lab 08 - Sidecar 패턴 + Volume

## 시험 문제

`default` namespace에 이름이 `log-pod`인 Pod를 생성하시오.

- `app` 컨테이너:
  - image: `busybox:latest`
  - 5초마다 현재 시각을 `/var/log/app.log`에 기록
  - command: `["/bin/sh", "-c", "while true; do echo $(date) >> /var/log/app.log; sleep 5; done"]`

- `sidecar` 컨테이너:
  - image: `busybox:latest`
  - `/var/log/app.log`를 실시간으로 읽어 stdout으로 출력
  - command: `["/bin/sh", "-c", "tail -f /var/log/app.log"]`

- 두 컨테이너는 `emptyDir` 볼륨(`shared-logs`)을 `/var/log`에 마운트하여 공유

---

- [풀이](solution/)
- [삭제](cleanup/)
