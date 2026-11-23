# 풀이

빠른 길: 뼈대를 명령으로 만들고 나머지를 손으로 붙인다.

```bash
kubectl -n autoscale autoscale deploy api --name=api-hpa --min=2 --max=8 --cpu-percent=60 \
  --dry-run=client -o yaml > hpa.yaml
# hpa.yaml에 memory 지표와 behavior 추가 (solution.yaml 참고)
kubectl apply -f hpa.yaml

kubectl -n autoscale get hpa api-hpa
kubectl -n autoscale describe hpa api-hpa   # Metrics 두 줄, Behavior 확인
```

## 핵심

- 사용률(%)은 `type: Utilization` + `averageUtilization`, 절대값은 `type: AverageValue` + `averageValue`다. 헷갈리면 감점이다.
- `behavior.scaleDown.policies[].type`은 `Pods`(개수) 또는 `Percent`(비율)다.
- 문서: "HorizontalPodAutoscaler Walkthrough", "Horizontal Pod Autoscaling"의 *Configurable scaling behavior* 절.
