# 풀이

```bash
kubectl apply -f solution.yaml
kubectl -n shop describe httproute shop-route   # Accepted=True, ResolvedRefs=True

# 확인: Gateway 데이터플레인 Service(NGF 2.x: shop-gw-nginx)의 NodePort로 호출
kubectl -n shop get svc shop-gw-nginx
NODE=$(kubectl get node cka-worker -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
PORT=$(kubectl -n shop get svc shop-gw-nginx -o jsonpath='{.spec.ports[?(@.port==80)].nodePort}')
for i in $(seq 20); do curl -s -H 'Host: shop.local' http://$NODE:$PORT/; done | sort | uniq -c   # v1 약 16, v2 약 4
curl -s -H 'Host: shop.local' -H 'x-canary: true' http://$NODE:$PORT/                          # 항상 v2
```

## 핵심

- 한 rule의 `matches` 항목끼리는 OR, 한 항목 안의 path와 headers는 AND다.
- `weight`는 비율이라 합이 100일 필요는 없다(80/20 = 4/1).
- 헤더 rule은 path를 생략하면 기본 `PathPrefix /`가 붙는다. 조건이 더 많은 match(헤더 포함)가 우선한다.
- 문서: gateway-api.sigs.k8s.io의 "HTTP traffic splitting", "HTTP header matching". 시험에서 이 사이트를 볼 수 있는지 미리 확인해 둔다.
