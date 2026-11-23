# Mock 02 - Gateway API 카나리 (가중치 분배 + 헤더 라우팅)

## 시험 문제

`shop` namespace에 Service `app-v1`, `app-v2`와 Gateway `shop-gw`(HTTP 80 리스너)가 있다.
다음 HTTPRoute를 만드시오.

- 이름: `shop-route`, Gateway `shop-gw`에 연결
- 호스트: `shop.local`
- 헤더 `x-canary: true`가 있는 요청은 **전부** `app-v2:80`으로
- 나머지 `/` 요청은 `app-v1` **80%**, `app-v2` **20%**

> 목표 시간: 7분

---

- [사전 준비](setup/)
- [풀이](solution/)
- [삭제](cleanup/)
