# 삭제

```bash
kubectl delete -f ../solution/solution.yaml
kubectl delete -f ../setup/setup.yaml
kubectl delete secret web-tls-secret -n web
kubectl delete namespace web

# NGINX Gateway Fabric 제거
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.2.2/deploy/nodeport/deploy.yaml
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.2.2/deploy/crds.yaml

# Gateway API CRD는 직접 설치했을 때만 지운다 (A100 kind 환경은 기본 구성이라 남긴다)
# kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.3.0/standard-install.yaml
```
