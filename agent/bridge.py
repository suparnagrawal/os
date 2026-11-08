"""Small bridge between the host-side agent and xv6 running in QEMU."""

import os
from pathlib import Path
import re
import select
import shutil
import subprocess
import tempfile
import time


ROOT = Path(__file__).resolve().parent.parent
OPERATIONS = {"list_files": "LIST", "read_file": "READ"}


class BridgeError(RuntimeError):
    pass


def validate_action(name, args):
    """Accept only our two tools and simple absolute xv6 paths."""
    if name not in OPERATIONS:
        raise ValueError("Unknown tool. Use list_files or read_file.")
    if not isinstance(args, dict) or set(args) != {"path"}:
        raise ValueError("The tool requires exactly one argument: path.")

    path = args["path"]
    if not isinstance(path, str) or not re.fullmatch(r"/[A-Za-z0-9_./-]{0,79}", path):
        raise ValueError("Use an absolute xv6 path with simple characters.")
    parts = path[1:].split("/") if path != "/" else []
    if any(not part or part in (".", "..") or len(part) > 14 for part in parts):
        raise ValueError("Each path component must be 1-14 characters; . and .. are not allowed.")
    return path


def build_images(root=ROOT):
    result = subprocess.run(
        ["make", "xv6.img", "agent-fs.img"], cwd=root,
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
    )
    if result.returncode:
        raise BridgeError("xv6 build failed:\n" + result.stdout[-3000:])


class QemuBridge:
    def __init__(self, root=ROOT):
        self.root = Path(root).resolve()
        self.process = None
        self.temp_dir = None
        self.buffer = bytearray()
        self.worker_pid = None

    def __enter__(self):
        self.start()
        return self

    def __exit__(self, *_):
        self.close()

    def start(self):
        qemu = shutil.which("qemu-system-i386") or shutil.which("qemu-system-x86_64")
        if not qemu:
            raise BridgeError("QEMU is not installed.")

        for image in ("xv6.img", "agent-fs.img"):
            if not (self.root / image).exists():
                raise BridgeError(f"Missing {image}; build the project first.")

        # Private copies keep the original images unchanged and avoid disk locks.
        self.temp_dir = tempfile.TemporaryDirectory(prefix="xv6-agent-")
        for image in ("xv6.img", "agent-fs.img"):
            shutil.copy(self.root / image, Path(self.temp_dir.name) / image)

        qemu_env = os.environ.copy()
        qemu_env.pop("GEMINI_API_KEY", None)
        qemu_env.pop("GOOGLE_API_KEY", None)
        self.process = subprocess.Popen(
            [qemu, "-display", "none", "-monitor", "none", "-serial", "stdio",
             "-no-reboot", "-smp", "1", "-m", "512",
             "-drive", "file=xv6.img,index=0,media=disk,format=raw",
             "-drive", "file=agent-fs.img,index=1,media=disk,format=raw"],
            cwd=self.temp_dir.name,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            bufsize=0,
            env=qemu_env,
        )

        deadline = time.monotonic() + 30
        self._read_until(b"$ ", deadline)
        self._send(b"agent_worker\n")
        while True:
            match = re.fullmatch(rb"@XV6 READY ([0-9]+)", self._readline(deadline))
            if match:
                self.worker_pid = int(match.group(1))
                return

    def close(self):
        if self.process and self.process.poll() is None:
            self.process.terminate()
            try:
                self.process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                self.process.kill()
                self.process.wait()
        if self.process:
            self.process.stdin.close()
            self.process.stdout.close()
        if self.temp_dir:
            self.temp_dir.cleanup()

    def _send(self, data):
        if not self.process or self.process.poll() is not None:
            raise BridgeError("QEMU is not running.")
        self.process.stdin.write(data)
        self.process.stdin.flush()

    def _read_until(self, marker, deadline):
        while marker not in self.buffer:
            remaining = deadline - time.monotonic()
            if remaining <= 0 or not select.select([self.process.stdout], [], [], remaining)[0]:
                raise BridgeError("Timed out waiting for xv6.")
            chunk = os.read(self.process.stdout.fileno(), 4096)
            if not chunk:
                raise BridgeError("QEMU exited unexpectedly.")
            self.buffer.extend(chunk)

        end = self.buffer.index(marker) + len(marker)
        result = bytes(self.buffer[:end])
        del self.buffer[:end]
        return result

    def _readline(self, deadline):
        return self._read_until(b"\n", deadline).rstrip(b"\r\n")

    def execute(self, name, args):
        path = validate_action(name, args)
        request = f"{OPERATIONS[name]} {path}".encode()
        content = bytearray()

        self._send(request + b"\n")
        deadline = time.monotonic() + 10
        while True:
            line = self._readline(deadline)
            if not line or line == request:  # xv6 echoes console input
                continue
            if not line.startswith(b"@XV6 "):
                raise BridgeError("Unexpected response from xv6.")

            message = line[len(b"@XV6 "):]
            if message.startswith(b"DATA "):
                try:
                    content.extend(bytes.fromhex(message[5:].decode()))
                except ValueError as exc:
                    raise BridgeError("Invalid data from xv6.") from exc
            elif message.startswith(b"DONE ERROR "):
                return {"ok": False, "path": path, "error": message[11:].decode()}
            elif message in (b"DONE OK", b"DONE TRUNCATED"):
                try:
                    text = content.decode("utf-8")
                except UnicodeDecodeError:
                    return {"ok": False, "path": path, "error": "not_utf8_text"}
                return {
                    "ok": True,
                    "path": path,
                    "content": text,
                    "truncated": message == b"DONE TRUNCATED",
                }
            else:
                raise BridgeError("Invalid response from xv6.")
