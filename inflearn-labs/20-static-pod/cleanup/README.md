# 삭제

```bash
# master 노드에 접속하여 manifest 파일 삭제
docker exec -it cka-control-plane bash
rm /etc/kubernetes/manifests/static-web.yaml
exit

# Pod가 자동으로 종료됨 (약 10~30초)
kubectl get pod static-web-cka-control-plane
# Error from server (NotFound): pods "static-web-cka-control-plane" not found
```
