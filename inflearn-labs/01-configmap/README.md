# Lab 01 - ConfigMap 수정 (설정 관리)

## 시험 문제

`default` namespace에 `app-config` ConfigMap과 이를 참조하는 `web-app` Deployment가 배포되어 있다.
다음 요구사항에 맞게 ConfigMap을 수정하고 변경사항을 반영하시오.

- `APP_COLOR` 값을 `blue` → `green` 으로 변경
- `APP_ENV` 키 추가, 값: `production`
- `web-app` Deployment에 변경사항 반영

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
