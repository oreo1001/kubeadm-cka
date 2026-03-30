# 풀이

## 풀이 명령어

```bash
kubectl apply -f solution.yaml

# 메인 컨테이너 로그 확인 (파일에 기록됨)
kubectl exec app-with-sidecar -c app -- cat /var/log/app/app.log

# Sidecar가 수집한 로그 확인 (stdout)
kubectl logs app-with-sidecar -c log-collector

# 두 컨테이너가 같은 볼륨 공유 확인
kubectl describe pod app-with-sidecar
```

## 핵심 개념

### Sidecar 패턴이란

```
[Pod]
  ├── app 컨테이너        → /var/log/app/app.log 에 로그 기록
  │                              ↕  (emptyDir 공유 볼륨)
  └── log-collector 컨테이너 → 로그 파일 읽어서 stdout으로 출력
                                     ↓
                              kubectl logs / 중앙 로그 수집기
```

- `emptyDir`: Pod가 살아있는 동안만 존재하는 임시 볼륨. 컨테이너 간 데이터 공유에 사용
- Sidecar는 메인 컨테이너와 **같은 Pod** 안에서 동작 → 네트워크/볼륨 공유
- `tail -f`: 파일에 새 내용이 추가될 때마다 실시간 출력

### 주요 Pod 디자인 패턴

| 패턴 | 설명 | 예시 |
|------|------|------|
| Sidecar | 메인 컨테이너 기능 보조 | 로그 수집, 프록시 |
| Ambassador | 외부 통신 프록시 | DB 프록시, 서비스 메시 |
| Adapter | 출력 형식 변환 | 메트릭 포맷 변환 |
