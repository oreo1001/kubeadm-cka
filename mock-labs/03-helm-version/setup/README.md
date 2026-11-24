# 사전 준비

kubectl을 쓰는 곳(A100 호스트)에 helm이 있어야 한다. A100 kind: `setup/run.sh`가 없으면 `~/.local/bin`에 설치한다.

```bash
helm version || (curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash)
```
