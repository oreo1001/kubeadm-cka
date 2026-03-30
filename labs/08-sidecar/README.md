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

## 풀이

```bash
kubectl apply -f solution.yaml

# 확인
kubectl get pod log-pod

# app 컨테이너 로그 (직접 파일 확인)
kubectl exec log-pod -c app -- tail /var/log/app.log

# sidecar 컨테이너 로그 (stdout)
kubectl logs log-pod -c sidecar -f
```

## 핵심 개념

- **Sidecar 패턴**: 주 컨테이너를 보조하는 컨테이너를 같은 Pod에 배치
- **emptyDir**: Pod 수명 동안 존재하는 임시 볼륨. Pod 삭제 시 데이터 소멸
- 같은 Pod의 컨테이너들은 볼륨을 통해 파일 공유 가능
- 대표적인 Sidecar 사용 사례: 로그 수집, 프록시(Istio), 설정 리로더
