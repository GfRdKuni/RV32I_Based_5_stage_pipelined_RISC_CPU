#!/usr/bin/env python3
"""Run bounded, self-checking simulations of the vendor-independent CPU core."""
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
SOURCES = [str(ROOT / line.strip()) for line in
           (ROOT / "tests/core_sources.f").read_text().splitlines()
           if line.strip() and not line.startswith("#")]


def main():
    compiler = os.environ.get("IVERILOG", "iverilog")
    runtime = os.environ.get("VVP", "vvp")
    for executable in (compiler, runtime):
        if not shutil.which(executable):
            raise RuntimeError(f"Required tool not found: {executable}")
    with tempfile.TemporaryDirectory(prefix="riscv-core-check-") as tmp:
        for top in ("application_check", "alu_check", "memory_check"):
            binary = Path(tmp) / top
            command = [compiler, "-g2012", "-Wall"]
            if os.environ.get("IVERILOG_LIBDIR"):
                command += ["-B", os.environ["IVERILOG_LIBDIR"]]
            command += ["-s", top, "-o", str(binary)] + SOURCES
            command += [str(ROOT / f"tests/{top}.sv")]
            subprocess.run(command, cwd=tmp, check=True, timeout=30)
            result = subprocess.run([runtime, "-n", str(binary)], cwd=tmp,
                                    check=True, timeout=30, text=True,
                                    stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            print(result.stdout, end="", flush=True)
            if f"PASS {top}" not in result.stdout:
                raise RuntimeError(f"Missing completion marker for {top}")
    print("PASS portable CPU checks")


if __name__ == "__main__":
    try:
        main()
    except (OSError, RuntimeError, subprocess.SubprocessError) as exc:
        if isinstance(exc, subprocess.CalledProcessError) and exc.stdout:
            print(exc.stdout, end="", file=sys.stderr)
        print(f"FAIL: {exc}", file=sys.stderr)
        sys.exit(1)
