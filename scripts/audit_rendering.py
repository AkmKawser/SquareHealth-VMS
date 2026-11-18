#!/usr/bin/env python3
"""
scripts/audit_rendering.py
Bridge entry point for GitHub Actions CI delegating to AI_Pair_Programming/scripts/audit_rendering.py.
"""
import sys
import subprocess
from pathlib import Path

ROOT_DIR = Path(__file__).resolve().parent.parent
TARGET_SCRIPT = ROOT_DIR / "AI_Pair_Programming" / "scripts" / "audit_rendering.py"

if __name__ == "__main__":
    res = subprocess.run([sys.executable, "-B", str(TARGET_SCRIPT)] + sys.argv[1:])
    sys.exit(res.returncode)
