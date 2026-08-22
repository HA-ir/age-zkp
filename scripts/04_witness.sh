#!/usr/bin/env bash
set -euo pipefail

echo "=== 04: Compute witness ==="
node build/age_verification_js/generate_witness.js \
    build/age_verification_js/age_verification.wasm \
    input.json build/witness.wtns

echo ""
echo "Witness generated successfully."
echo "Exporting witness as JSON for inspection..."
npx snarkjs wtns export json build/witness.wtns build/witness.json
echo "Witness JSON written to build/witness.json"
