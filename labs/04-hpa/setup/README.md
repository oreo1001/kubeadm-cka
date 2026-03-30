# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## metrics-server 설치 (HPA에 필요)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# metrics-server TLS 검증 비활성화 (로컬 환경용)
kubectl patch deployment metrics-server \
  -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```
