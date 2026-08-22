#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR/.."

echo "=== Generating commitment and input.json ==="
node compute_commitment.js
echo ""

bash scripts/01_compile.sh
echo ""
bash scripts/02_ptau.sh
echo ""
bash scripts/03_setup.sh
echo ""
bash scripts/04_witness.sh
echo ""
bash scripts/05_prove.sh
echo ""
bash scripts/06_verify.sh
echo ""
echo "✅ All done!"
