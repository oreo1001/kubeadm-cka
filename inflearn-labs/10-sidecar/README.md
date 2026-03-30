# Lab 10 - Sidecar 패턴을 활용한 로그 수집 환경 구축

## 시험 문제

`default` namespace에 애플리케이션 로그를 파일(`/var/log/app/app.log`)에 기록하는
`app` 컨테이너가 있다. 다음 요구사항에 맞는 Pod를 생성하시오.

- Pod 이름: `app-with-sidecar`
- 메인 컨테이너: `app` (image: `busybox`, `/var/log/app/app.log`에 로그 기록)
- Sidecar 컨테이너: `log-collector` (image: `busybox`, 로그 파일을 stdout으로 출력)
- 공유 볼륨: `log-volume` (emptyDir), 마운트 경로: `/var/log/app`

---

- [풀이](solution/)
- [삭제](cleanup/)
