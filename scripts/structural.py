#!/usr/bin/env python3
"""Check public-core hierarchy and lowered RTL structure with Yosys."""
import os
from pathlib import Path
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]


def main():
    yosys = os.environ.get("YOSYS", "yosys")
    if not shutil.which(yosys):
        raise RuntimeError(f"Required tool not found: {yosys}")
    sources = [ROOT / line.strip() for line in
               (ROOT / "tests/core_sources.f").read_text().splitlines()
               if line.strip() and not line.startswith("#")]
    quoted = [f'"{path.as_posix()}"' for path in sources]
    script = "read_verilog -sv " + " ".join(quoted) + "; "
    script += "hierarchy -check -top cpu_core; proc; opt; check -assert"
    log = ROOT / "build/structural/yosys.log"
    log.parent.mkdir(parents=True, exist_ok=True)
    result = subprocess.run([yosys, "-p", script], cwd=ROOT, text=True,
                            stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                            timeout=120)
    log.write_text(result.stdout, encoding="utf-8")
    if result.returncode:
        print("\n".join(result.stdout.splitlines()[-80:]), file=sys.stderr)
        raise RuntimeError(f"Yosys failed; full log: {log}")
    for line in result.stdout.splitlines():
        if line.startswith("Warning:") or "Found and reported" in line:
            print(line)
    print("PASS public cpu_core structural check (hierarchy/proc/opt/check -assert)")
    print(f"Log: {log}")


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, subprocess.SubprocessError) as exc:
        print(f"FAIL: {exc}", file=sys.stderr)
        sys.exit(1)
