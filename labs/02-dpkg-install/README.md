# Lab 02 - 패키지 설치 (dpkg -i + systemctl)

## 시험 문제

`worker-1` 노드(192.168.121.11)에 SSH로 접속하여 다음 작업을 수행하시오.

1. `/opt/packages/` 디렉토리에 있는 `nginx` `.deb` 패키지를 `dpkg -i`로 설치하시오.
2. `nginx` 서비스를 `systemctl`로 시작하고 부팅 시 자동 시작되도록 설정하시오.
3. 서비스 상태를 확인하시오.

## 실습 준비

```bash
# linux/ 디렉토리에서 worker-1 접속
cd /home/anvi1001/kubeadm-cka/linux
vagrant ssh worker-1

# 패키지 디렉토리 생성 및 nginx 다운로드
sudo mkdir -p /opt/packages
cd /opt/packages
sudo apt-get download nginx
ls /opt/packages/
```

## 풀이

```bash
# 1. worker-1 접속
cd /home/anvi1001/kubeadm-cka/linux
vagrant ssh worker-1

# 2. dpkg로 nginx 설치
sudo dpkg -i /opt/packages/nginx_*.deb
sudo dpkg -i /opt/packages/nginx_1.18.0-6ubuntu14.8_amd64.deb

# 의존성 오류 발생 시
sudo apt-get install -f

# 3. 서비스 시작 및 부팅 시 자동 시작 설정
sudo systemctl start nginx
sudo systemctl enable nginx

# 4. 상태 확인
sudo systemctl status nginx

# 5. 설치 확인
dpkg -l | grep nginx
dpkg -L nginx   # nginx가 설치한 파일 목록
```

## 삭제

```bash
sudo systemctl stop nginx
sudo systemctl disable nginx
sudo dpkg -P nginx
```

## 핵심 명령어

| 명령어 | 설명 |
|--------|------|
| `dpkg -i <file>.deb` | deb 패키지 설치 |
| `dpkg -r <package>` | 패키지 제거 (설정 유지) |
| `dpkg -P <package>` | 패키지 완전 제거 (설정 포함) |
| `dpkg -l` | 설치된 패키지 목록 |
| `dpkg -L <package>` | 패키지가 설치한 파일 목록 |
| `systemctl start/stop/restart` | 서비스 시작/중지/재시작 |
| `systemctl enable/disable` | 부팅 시 자동 시작 설정 |
| `systemctl status` | 서비스 상태 확인 |
| `journalctl -u <service>` | 서비스 로그 확인 |
