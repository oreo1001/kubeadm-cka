# 풀이

## 장애 시뮬레이션

```bash
# [master 노드에서] 문제 1: kube-apiserver manifest에 잘못된 포트 주입
sudo cp /etc/kubernetes/manifests/kube-apiserver.yaml /tmp/kube-apiserver.yaml.bak
sudo sed -i 's/--secure-port=6443/--secure-port=9999/' \
  /etc/kubernetes/manifests/kube-apiserver.yaml

# [worker-1 노드에서] 문제 2: kubelet 강제 중지
sudo systemctl stop kubelet
```

## 문제 1: kube-apiserver 복구

```bash
# kubectl 사용 불가 → crictl로 컨테이너 직접 확인
sudo crictl ps -a | grep apiserver
sudo crictl logs $(sudo crictl ps -a --name kube-apiserver -q)

# 또는 kubelet 로그에서 원인 확인
sudo journalctl -u kubelet -n 50 --no-pager | grep -i error

# manifest 파일 수정
sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
# --secure-port=9999 → --secure-port=6443

# kubelet이 변경 감지 후 자동 재시작 (최대 20초)
watch sudo crictl ps | grep apiserver

# 복구 확인
kubectl get nodes
```

## 문제 2: kubelet 복구

```bash
# [worker-1에서] 상태 확인
sudo systemctl status kubelet
sudo journalctl -u kubelet -n 30 --no-pager

# kubelet 재시작 및 자동 시작 등록
sudo systemctl start kubelet
sudo systemctl enable kubelet

# [master에서] 노드 상태 확인
kubectl get nodes
kubectl describe node worker-1 | grep -A5 Conditions
```

## 핵심 개념

### Static Pod 동작 원리

```
kubelet → /etc/kubernetes/manifests/*.yaml 감시
       → 변경 감지 시 컨테이너 자동 재생성
```

| Static Pod | 매니페스트 위치 |
|-----------|------|
| kube-apiserver | `/etc/kubernetes/manifests/kube-apiserver.yaml` |
| etcd | `/etc/kubernetes/manifests/etcd.yaml` |
| kube-scheduler | `/etc/kubernetes/manifests/kube-scheduler.yaml` |
| kube-controller-manager | `/etc/kubernetes/manifests/kube-controller-manager.yaml` |

### 장애 진단 명령어

```bash
# 컨테이너 런타임 직접 조회 (kubectl 불가 시)
sudo crictl ps -a
sudo crictl logs <container-id>

# kubelet 로그
sudo journalctl -u kubelet -f
sudo systemctl status kubelet

# 컴포넌트 상태 (apiserver 복구 후)
kubectl get componentstatuses
kubectl get nodes
```
