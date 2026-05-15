#!/usr/bin/env bash
set -euo pipefail

python - <<'PY'
import torch

print(f"torch: {torch.__version__}")
print(f"cuda available: {torch.cuda.is_available()}")
if not torch.cuda.is_available():
    raise SystemExit("CUDA is not available to PyTorch")

print(f"cuda version: {torch.version.cuda}")
print(f"gpu count: {torch.cuda.device_count()}")
print(f"gpu 0: {torch.cuda.get_device_name(0)}")
PY
