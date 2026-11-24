# 사전 준비

노드 접속: `docker exec -it cka-control-plane bash` (A100 kind. root라 `sudo` 불필요)

```bash
# 노드에서 hostPath 디렉토리 생성 (Pod가 어느 노드에 뜰지 모르므로 A100에서는 모든 노드에 만든다)
sudo mkdir -p /mnt/data

# StorageClass 생성 (lab 10 선행 필요, 이 setup/ 폴더 기준 경로)
kubectl apply -f ../../10-storageclass/solution/solution.yaml
```
