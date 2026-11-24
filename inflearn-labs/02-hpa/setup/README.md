# 사전 준비

## 리소스 적용

```bash
kubectl apply -f setup.yaml
```

## metrics-server 확인

A100 kind 환경은 `env-up` 때 metrics-server(`--kubelet-insecure-tls` 패치 포함)가 이미 설치돼 있다. 준비 대기만 한다.

```bash
# metrics-server 준비 대기
kubectl wait --for=condition=available deployment/metrics-server -n kube-system --timeout=120s
```
