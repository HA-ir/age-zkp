#!/usr/bin/env bash
set -euo pipefail

echo "=== 02: Powers of Tau (Phase 1) ==="
npx snarkjs powersoftau new bn128 12 build/pot12_0000.ptau -v
echo ""
echo "Contribute entropy to the ceremony..."
npx snarkjs powersoftau contribute build/pot12_0000.ptau build/pot12_0001.ptau \
    --name="first contribution" -v -e="$(date +%s%N)"
echo ""
echo "Prepare phase 2..."
npx snarkjs powersoftau prepare phase2 build/pot12_0001.ptau build/pot12_final.ptau -v
