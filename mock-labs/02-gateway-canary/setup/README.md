# 사전 준비

Gateway API CRD와 NGINX Gateway Fabric이 없으면 `inflearn-labs/07-gateway-migration/setup/README.md`의
"Gateway API CRD 설치", "NGINX Gateway Fabric 설치"를 먼저 한다(GatewayClass 이름 `nginx`).

```bash
kubectl apply -f setup.yaml
kubectl -n shop get gateway shop-gw   # PROGRAMMED=True 확인
```
