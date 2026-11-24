# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## metrics-server 설치 (HPA에 필요)

> A100 kind 환경에는 env-up 때 이미 설치돼 있다. `kubectl top nodes`로 확인만 한다.

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# metrics-server TLS 검증 비활성화 (로컬 환경용)
kubectl patch deployment metrics-server \
  -n kube-system \
  --type=json \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
```
