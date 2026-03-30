# Lab 02 - 패키지 설치 (dpkg -i + systemctl)

## 시험 문제

`worker-1` 노드(192.168.56.11)에 SSH로 접속하여 다음 작업을 수행하시오.

1. `/opt/packages/` 디렉토리에 있는 `.deb` 패키지를 `dpkg -i`로 설치하시오.
2. 설치된 서비스를 `systemctl`로 시작하고 부팅 시 자동 시작되도록 설정하시오.
3. 서비스 상태를 확인하시오.

## 실습 준비 (패키지 다운로드 예시)

```bash
# worker-1에서 실행
sudo mkdir -p /opt/packages
cd /opt/packages

# 예시: etcd 클라이언트 deb 패키지 다운로드
# (실제 시험에서는 패키지가 이미 제공됨)
sudo apt-get download etcd-client
```

## 풀이

```bash
# 1. 노드에 SSH 접속
ssh ubuntu@192.168.56.11

# 2. dpkg로 패키지 설치
sudo dpkg -i /opt/packages/<package-name>.deb

# 의존성 오류 발생 시
sudo apt-get install -f

# 3. 서비스 시작 및 활성화
sudo systemctl start <service-name>
sudo systemctl enable <service-name>

# 4. 상태 확인
sudo systemctl status <service-name>

# 설치된 패키지 확인
dpkg -l | grep <package-name>

# 패키지가 설치한 파일 목록
dpkg -L <package-name>
```

## 핵심 명령어

| 명령어 | 설명 |
|--------|------|
| `dpkg -i <file>.deb` | deb 패키지 설치 |
| `dpkg -r <package>` | 패키지 제거 (설정 유지) |
| `dpkg -P <package>` | 패키지 완전 제거 |
| `dpkg -l` | 설치된 패키지 목록 |
| `dpkg -L <package>` | 패키지가 설치한 파일 목록 |
| `systemctl start/stop/restart` | 서비스 시작/중지/재시작 |
| `systemctl enable/disable` | 부팅 시 자동 시작 설정 |
| `systemctl status` | 서비스 상태 확인 |
| `journalctl -u <service>` | 서비스 로그 확인 |
