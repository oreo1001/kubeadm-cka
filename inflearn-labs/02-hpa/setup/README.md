# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## metrics-server 설치

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# 로컬 환경 TLS 우회 패치
kubectl patch deployment metrics-server \
  -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

# metrics-server 준비 대기
kubectl wait --for=condition=available deployment/metrics-server -n kube-system --timeout=120s
```
