#!/usr/bin/env bash
set -euo pipefail

echo "=== 01: Compile circuit ==="
circom age_verification.circom --r1cs --wasm --sym -o build -l ./node_modules

echo ""
echo "R1CS constraint info:"
npx snarkjs r1cs info build/age_verification.r1cs
