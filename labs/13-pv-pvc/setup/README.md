# 사전 준비

```bash
# master 노드에서 hostPath 디렉토리 생성
sudo mkdir -p /mnt/data

# StorageClass 생성 (lab 10 선행 필요)
kubectl apply -f ../10-storageclass/solution/solution.yaml
```
