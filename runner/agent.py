#!/usr/bin/env python3
"""CKA 실습 실행기 (A100 상주). 표준 라이브러리만 쓴다.

사이트(cka-prep)에 다음 작업을 묻고(pull), 허용된 동작만 runner/lab.sh로 실행한 뒤 결과를 보고한다.
A100에 새 포트를 열지 않고, 서버 접속 키를 사이트에 두지 않는다.

설정: ~/.config/cka-runner/env
  SITE_URL=https://<사이트 주소>
  RUNNER_TOKEN=<사이트의 RUNNER_TOKEN과 같은 값, 32자 이상>
  LAB_DIR=/home/<사용자>/cka-lab        (생략하면 이 파일 기준 상위 폴더)
"""
import json
import os
import re
import signal
import subprocess
import sys
import threading
import time
import urllib.error
import urllib.request
from pathlib import Path

ACTIONS = {"env-up", "env-reset", "env-down", "lab-setup", "lab-cleanup"}
LAB_ACTIONS = {"lab-setup", "lab-cleanup"}
LAB_RE = re.compile(r"^(labs|inflearn|mock)-\d\d-[a-z0-9-]+$")
JOB_TIMEOUT = 15 * 60
REPORT_EVERY = 5


def log(msg):
    print(time.strftime("%H:%M:%S"), msg, flush=True)


def load_config(path=Path.home() / ".config/cka-runner/env"):
    cfg = {}
    if path.exists():
        for line in path.read_text().splitlines():
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                cfg[k.strip()] = v.strip()
    cfg.setdefault("LAB_DIR", str(Path(__file__).resolve().parent.parent))
    return cfg


def validate(job):
    """사이트가 보낸 작업을 다시 검증한다. 통과하면 lab.sh 인자 목록, 아니면 None."""
    if not isinstance(job, dict) or job.get("action") not in ACTIONS:
        return None
    action = job["action"]
    if action in LAB_ACTIONS:
        lab = job.get("lab")
        if not isinstance(lab, str) or not LAB_RE.match(lab):
            return None
        return [action, lab]
    return [action]


def after_job(args, ok, env):
    """작업 뒤 보고할 (env, activeLab, 이어서 할 동작). env는 lab.sh status로 확인한 실제 값('off'|'ready')."""
    action = args[0]
    if action == "lab-setup":
        # 준비가 실패해도 반쯤 깔렸을 수 있으니 활성으로 둬서 정리·초기화 버튼이 남게 한다
        return (env, args[1], None)
    if action == "lab-cleanup":
        return (env, None, None) if ok else (env, args[1], "env-reset")
    return (env, None, None)


class Site:
    def __init__(self, url, token):
        self.url = url.rstrip("/")
        self.token = token

    def post(self, path, body):
        req = urllib.request.Request(
            self.url + path,
            data=json.dumps(body).encode(),
            headers={"Authorization": f"Bearer {self.token}", "content-type": "application/json"},
            method="POST",
        )
        with urllib.request.urlopen(req, timeout=20) as r:
            return json.loads(r.read().decode() or "{}")

    def report(self, body, tries=1):
        """보고. tries번까지 백오프로 재시도. 성공하면 True."""
        delay = 2
        for i in range(tries):
            try:
                self.post("/api/runner/report", body)
                return True
            except Exception as e:  # 네트워크·콜드스타트
                log(f"report 실패({i + 1}/{tries}): {e}")
                if i + 1 < tries:
                    time.sleep(delay)
                    delay = min(delay * 2, 20)
        return False


class Agent:
    def __init__(self, site, lab_dir):
        self.site = site
        self.lab_dir = lab_dir
        self.pending = []  # 보내지 못한 최종 보고 — 다음 폴링 전에 다시 보낸다

    def lab(self, *args, timeout=JOB_TIMEOUT, on_line=None):
        """lab.sh 실행. 새 세션(프로세스 그룹)으로 띄워 시간 초과면 자식까지 함께 죽인다. (returncode, 출력 줄)"""
        proc = subprocess.Popen(
            ["bash", str(Path(self.lab_dir) / "runner/lab.sh"), *args],
            cwd=self.lab_dir, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            text=True, encoding="utf-8", errors="replace", bufsize=1, start_new_session=True,
        )
        lines = []

        def reader():
            for line in proc.stdout:
                line = line.rstrip()[:300]
                lines.append(line)
                if on_line:
                    on_line(line)

        t = threading.Thread(target=reader, daemon=True)
        t.start()
        try:
            proc.wait(timeout=timeout)
        except subprocess.TimeoutExpired:
            os.killpg(proc.pid, signal.SIGKILL)
            proc.wait()
            lines.append(f"[agent] {timeout // 60}분이 지나 중단했어요")
            if on_line:
                on_line(lines[-1])
        t.join(timeout=5)
        return proc.returncode, lines

    def env_status(self):
        code, out = self.lab("status", timeout=60)
        return out[-1] if code == 0 and out and out[-1] in ("off", "ready") else "unknown"

    def flush_pending(self):
        while self.pending:
            if not self.site.report(self.pending[0], tries=2):
                return False
            self.pending.pop(0)
        return True

    def run_job(self, job):
        args = validate(job)
        job_id = job.get("id", "?") if isinstance(job, dict) else "?"
        if args is None:
            self.site.report({"jobId": job_id, "status": "failed", "message": "허용되지 않은 작업"}, tries=3)
            return
        busy_env = "starting" if args[0] in ("env-up", "env-reset") else "busy"
        self.site.report({"jobId": job_id, "status": "claimed", "env": busy_env, "log": [f"$ lab.sh {' '.join(args)}"]}, tries=3)

        buf, lock, last = [], threading.Lock(), [time.time()]

        def on_line(line):
            with lock:
                buf.append(line)
                if time.time() - last[0] >= REPORT_EVERY:
                    lines, buf[:] = buf[:], []
                    last[0] = time.time()
                else:
                    return
            self.site.report({"jobId": job_id, "status": "claimed", "log": lines})

        code, _ = self.lab(*args, on_line=on_line)
        ok = code == 0
        env, active, followup = after_job(args, ok, self.env_status())
        with lock:
            rest = buf[:]
        final = {
            "jobId": job_id, "status": "done" if ok else "failed",
            "message": None if ok else (rest[-1] if rest else f"종료 코드 {code}"),
            "log": rest, "env": env, "activeLab": active,
        }
        if not self.site.report(final, tries=6):
            self.pending.append(final)
        if followup == "env-reset":
            log("정리 실패 → 클러스터 초기화")
            self.site.report({"jobId": None, "status": "status", "env": "starting", "log": ["[agent] 정리가 실패해서 클러스터를 초기화해요"]})
            code, out = self.lab("env-reset")
            env = self.env_status()
            body = {"jobId": None, "status": "status", "env": env if code == 0 else "error", "activeLab": None, "log": out[-20:]}
            if not self.site.report(body, tries=6):
                self.pending.append(body)


def main():
    cfg = load_config()
    if not cfg.get("SITE_URL") or len(cfg.get("RUNNER_TOKEN", "")) < 32:
        sys.exit("~/.config/cka-runner/env 에 SITE_URL과 32자 이상 RUNNER_TOKEN을 넣어 주세요")
    agent = Agent(Site(cfg["SITE_URL"], cfg["RUNNER_TOKEN"]), cfg["LAB_DIR"])
    log(f"cka-runner: {agent.site.url} 폴링 시작 (LAB_DIR={cfg['LAB_DIR']})")
    # 시작할 때 실제 상태를 알린다 (손으로 켜 둔 클러스터도 자동 끄기 대상이 되게)
    agent.site.report({"jobId": None, "status": "status", "env": agent.env_status(), "log": ["[agent] 시작"]}, tries=3)
    interval = 60
    while True:
        try:
            if agent.flush_pending():
                res = agent.site.post("/api/runner/poll", {})
                interval = int(res.get("interval", 60))
                if res.get("job"):
                    log(f"job: {res['job']}")
                    agent.run_job(res["job"])
                    interval = 1
        except urllib.error.HTTPError as e:
            log(f"poll HTTP {e.code}")
        except Exception as e:
            log(f"poll 실패: {e}")
        time.sleep(max(1, min(interval, 120)))


if __name__ == "__main__":
    main()
