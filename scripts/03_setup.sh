#!/usr/bin/env bash
set -euo pipefail

echo "=== 03: Groth16 Phase 2 Setup ==="
npx snarkjs groth16 setup build/age_verification.r1cs \
    build/pot12_final.ptau build/age_verification_0000.zkey

echo ""
echo "Contribute to the circuit-specific zkey..."
npx snarkjs zkey contribute build/age_verification_0000.zkey \
    build/age_verification_final.zkey \
    --name="contributor" -v -e="$(date +%s%N)"

echo ""
echo "Export verification key..."
npx snarkjs zkey export verificationkey \
    build/age_verification_final.zkey build/verification_key.json
