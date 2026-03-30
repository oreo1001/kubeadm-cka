# Lab 09 - NetworkPolicy 배포

## 시험 문제

`production` namespace에 다음 요구사항을 만족하는 NetworkPolicy를 생성하시오.

- 이름: `allow-frontend-to-backend`
- `role=backend` label을 가진 Pod에 대해:
  - `role=frontend` label을 가진 Pod만 TCP 8080 포트로 접근 허용
  - 그 외 모든 Ingress 트래픽 차단
- Egress는 제한 없음

## 실습 준비

```bash
kubectl apply -f setup.yaml
```

## 풀이

```bash
kubectl apply -f solution.yaml

# 확인
kubectl describe networkpolicy allow-frontend-to-backend -n production

# 통신 테스트
# frontend → backend (허용되어야 함)
kubectl exec -n production frontend -- curl -s http://backend:8080

# blocked-pod → backend (차단되어야 함)
kubectl exec -n production blocked-pod -- curl -s --connect-timeout 3 http://backend:8080
```

## 핵심 개념

- NetworkPolicy는 CNI가 지원해야 동작함 (Calico, Cilium 지원 / Flannel 미지원)
- `podSelector: {}` → namespace 내 모든 Pod 대상
- `namespaceSelector` → 다른 namespace의 Pod 허용 가능
- NetworkPolicy가 없으면 기본적으로 모든 트래픽 허용
- NetworkPolicy가 하나라도 적용되면 해당 Pod는 명시된 트래픽만 허용
