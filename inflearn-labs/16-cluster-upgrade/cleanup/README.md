# 삭제

클러스터 업그레이드는 되돌릴 수 없습니다.

버전을 원복하려면 클러스터를 재구성하시오.

```bash
# [Windows] VM 삭제 후 재생성
vagrant destroy -f
vagrant up

# [WSL2] 클러스터 재설치
cd ansible && ansible-playbook playbooks/setup_cluster.yml
```
