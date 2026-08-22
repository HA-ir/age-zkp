#!/usr/bin/env bash
set -euo pipefail

echo "=== 05: Generate Groth16 proof ==="
npx snarkjs groth16 prove build/age_verification_final.zkey \
    build/witness.wtns build/proof.json build/public.json

echo ""
echo "Proof generated."
echo "  proof.json  → the Groth16 proof"
echo "  public.json → public inputs/outputs"
echo ""
echo "Public output:"
cat build/public.json
