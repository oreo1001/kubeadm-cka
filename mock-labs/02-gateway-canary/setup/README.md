# 사전 준비

Gateway API CRD와 NGINX Gateway Fabric(GatewayClass 이름 `nginx`)이 필요하다.
A100 kind: `setup/run.sh`가 NGF v2.2.2(Gateway API v1.3.0 호환, NodePort 배포판)를 설치하고 아래를 적용한다.
직접 설치할 때는 `labs/14-gateway-migration/setup/README.md`의 "NGINX Gateway Fabric 설치"를 따른다.

```bash
kubectl apply -f setup.yaml
kubectl -n shop get gateway shop-gw   # PROGRAMMED=True 확인
```
