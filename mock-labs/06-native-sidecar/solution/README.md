# 풀이

```bash
kubectl -n sidecar edit deploy logger      # 또는 get -o yaml > f.yaml 로 고친 뒤 apply
# solution.yaml처럼 initContainers + restartPolicy: Always + 공유 emptyDir 추가

kubectl -n sidecar rollout status deploy/logger
kubectl -n sidecar get pod                 # READY 2/2
kubectl -n sidecar logs deploy/logger -c log-tail
```

## 핵심

- native sidecar는 `initContainers`에 넣고 **`restartPolicy: Always`**를 준다(1.29부터 기본 활성, 1.33 GA).
  일반 init 컨테이너와 달리 끝나지 않아도 다음 컨테이너가 뜬다.
- 문제가 "sidecar"라고만 하고 native를 요구하지 않으면 `containers`에 두 번째 컨테이너로 넣어도 된다. **문제 문구를 그대로 따른다.**
- 볼륨 이름과 `mountPath`는 두 컨테이너가 같아야 한다.
- 문서: "Sidecar Containers".
