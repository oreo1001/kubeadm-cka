# 풀이

## 풀이 명령어

```bash
# 1. 노드 상태 확인
kubectl get nodes
kubectl describe node worker-1 | grep -A 10 Conditions

# 2. worker-1에 SSH 접속
ssh vagrant@192.168.56.11

# 3. kubelet 상태 확인
sudo systemctl status kubelet

# 4. 로그로 원인 파악
sudo journalctl -u kubelet -n 50 --no-pager

# 5. kubelet 재시작
sudo systemctl start kubelet
sudo systemctl enable kubelet   # 부팅 시 자동 시작 보장

# 6. 상태 확인
sudo systemctl status kubelet

exit

# 7. [WSL2] 노드 복구 확인 (약 30초~1분 소요)
kubectl get nodes
# NAME       STATUS   ROLES    AGE   VERSION
# worker-1   Ready    <none>   Xd    v1.31.x
```

## 핵심 개념

| 명령어 | 설명 |
|--------|------|
| `systemctl status kubelet` | kubelet 서비스 상태 확인 |
| `journalctl -u kubelet -n 50` | kubelet 최근 50줄 로그 |
| `systemctl start kubelet` | kubelet 시작 |
| `systemctl enable kubelet` | 부팅 시 자동 시작 등록 |

### 자주 나오는 kubelet 장애 원인

| 증상 | 원인 | 해결 |
|------|------|------|
| `NotReady` | kubelet 중지 | `systemctl start kubelet` |
| `NotReady` | 설정 파일 오류 | `/var/lib/kubelet/config.yaml` 확인 |
| `NotReady` | containerd 중지 | `systemctl start containerd` |
| `NotReady` | 디스크 풀 (DiskPressure) | 불필요한 이미지/로그 정리 |

- 시험에서는 `journalctl -u kubelet` 로그를 반드시 읽어야 원인 파악 가능
- `kubectl describe node`의 `Conditions` 섹션에서 힌트 확인
