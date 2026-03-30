# 풀이

## 풀이 명령어

```bash
# 1. worker-1 접속
vagrant ssh worker-1

# 2. dpkg로 nginx 설치
sudo dpkg -i /opt/packages/nginx_*.deb

# 의존성 오류 발생 시
sudo apt-get install -f

# 3. 서비스 시작 및 부팅 시 자동 시작 설정
sudo systemctl start nginx
sudo systemctl enable nginx

# 4. 상태 확인
sudo systemctl status nginx

# 5. 설치 확인
dpkg -l | grep nginx
dpkg -L nginx
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
