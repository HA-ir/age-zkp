#!/usr/bin/env bash
set -euo pipefail

echo "=== 06: Verify proof ==="
npx snarkjs groth16 verify build/verification_key.json \
    build/public.json build/proof.json
