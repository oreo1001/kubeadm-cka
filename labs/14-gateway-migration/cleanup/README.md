# 삭제

```bash
kubectl delete -f ../solution/solution.yaml
kubectl delete -f ../setup/setup.yaml
kubectl delete secret web-tls-secret -n web
kubectl delete namespace web

# Gateway API CRD 및 컨트롤러 제거
kubectl delete -f https://raw.githubusercontent.com/nginxinc/nginx-gateway-fabric/v1.4.0/deploy/default/deploy.yaml
kubectl delete -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
```
