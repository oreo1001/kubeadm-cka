# 삭제

```bash
# master 노드에 SSH 접속하여 manifest 파일 삭제
ssh vagrant@192.168.56.10
sudo rm /etc/kubernetes/manifests/static-web.yaml
exit

# Pod가 자동으로 종료됨 (약 10~30초)
kubectl get pod static-web-master
# Error from server (NotFound): pods "static-web-master" not found
```
