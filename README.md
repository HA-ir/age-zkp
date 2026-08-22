# Age Verification with Zero-Knowledge Proofs (ZKP)

A Circom-based Zero-Knowledge circuit using Groth16 zk-SNARKs to prove a user is of legal age (`age >= 18`) without revealing their exact age or identity.

## ✨ Features

- 🔒 **Privacy Preserving**: Proves `age >= 18` while keeping the exact age and salt private.
- 🔗 **Cryptographic Binding**: Uses Poseidon hash commitment (`Poseidon(age, salt) == commitment`) to link the proof to a specific identity/credential.
- ⚙️ **Full Tooling Pipeline**: Automates circuit compilation, Powers of Tau ceremony, Phase 2 trusted setup, witness generation, proof generation, and verification.
- 📜 **Smart Contract Ready**: Generates a Solidity verifier contract (`verifier.sol`) for on-chain proof validation.

## 📋 Prerequisites

- [Node.js](https://nodejs.org/) (v16+) & `npm`
- [Circom 2.0+](https://docs.circom.io/getting-started/installation/)
- `snarkjs` (installed locally via npm dependencies)

## 📦 Installation

Clone the repository and install dependencies:

```bash
git clone git@github.com:HA-ir/age-zkp.git
cd age-zkp
npm install
```

## 🚀 Quick Start (Makefile)

Run the full setup, witness generation, and proof verification in one step:

```bash
# Setup circuit + generate proof with default input.json
make

# Or test with a specific age
make prove AGE=25
```

### 🛠️ Other Make Commands

- `make setup` - One-time setup: compile circuit, generate PTAU, and perform Phase 2 setup.
- `make prove` - Compute commitment, calculate witness, and generate zk-SNARK proof.
- `make verify` - Verify the generated proof against the verification key.
- `make clean` - Remove all generated build artifacts.
- `make reset` - Clean build artifacts and remove `node_modules`.

## 📖 Manual Pipeline (Step-by-Step)

If you prefer running individual scripts:

```bash
# 1. Compile Circom circuit (R1CS, WASM, symbols)
bash scripts/01_compile.sh

# 2. Generate Powers of Tau ceremony (pot12)
bash scripts/02_ptau.sh

# 3. Phase 2 setup & verification key generation
bash scripts/03_setup.sh

# 4. Generate commitment and witness from input.json
bash scripts/04_witness.sh

# 5. Generate Groth16 zk-SNARK proof
bash scripts/05_prove.sh

# 6. Verify proof
bash scripts/06_verify.sh
```

## 🔍 Circuit Details

- **Circuit**: `age_verification.circom`
- **Public Inputs**: `commitment`
- **Private Inputs**: `age`, `salt`
- **Public Output**: `valid` (1 if `age >= 18`, 0 otherwise)

## 📄 License

MIT
