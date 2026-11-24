# 풀이

```bash
kubectl get nodes
kubectl describe node worker-1 | sed -n '/Conditions/,/Addresses/p'   # "Kubelet stopped posting node status" (A100 kind: cka-worker)

ssh worker-1                           # A100 kind: docker exec -it cka-worker bash (root라 sudo 불필요)
sudo systemctl status kubelet          # activating (auto-restart) 반복
sudo journalctl -u kubelet -n 50 --no-pager
#  -> "unable to load client CA file /etc/kubernetes/pki/ca-cert.crt: no such file"
sudo vi /var/lib/kubelet/config.yaml   # clientCAFile: /etc/kubernetes/pki/ca.crt
sudo systemctl restart kubelet

sudo journalctl -u kubelet -n 30 --no-pager
#  -> "dial tcp <master>:6553: connect: connection refused"
sudo vi /etc/kubernetes/kubelet.conf   # server: https://<master>:6443
sudo systemctl restart kubelet
sudo systemctl is-enabled kubelet      # enabled (재부팅 유지 조건)
exit

kubectl get nodes                      # worker-1 Ready
```

## 핵심: kubelet 관련 파일 3개

| 파일 | 내용 | 자주 나오는 고장 |
|---|---|---|
| `/var/lib/kubelet/config.yaml` | KubeletConfiguration | CA 경로, staticPodPath, cgroupDriver |
| `/etc/kubernetes/kubelet.conf` | API 서버 접속 kubeconfig | 서버 주소와 포트, 인증서 경로 |
| `/usr/lib/systemd/system/kubelet.service.d/10-kubeadm.conf` | 위 두 파일을 kubelet에 넘기는 drop-in | 플래그 오타, 파일 경로 |

- 원인이 둘이면 **하나를 고칠 때마다 `journalctl`로 다음 에러를 본다**.
- `systemctl status kubelet`의 `Drop-In:` 줄에서 실제로 읽는 설정 파일을 확인한다.
