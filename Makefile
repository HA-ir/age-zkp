BUILD   := build
SCRIPTS := scripts

.PHONY: all setup compile ptau phase2 prove verify clean reset help

# Read the current age from input.json for display.
CURRENT_AGE := $(shell python3 -c "import json; print(json.load(open('input.json')).get('age','?'))" 2>/dev/null || echo "?")

# ── Top-level ─────────────────────────────────────────────────

all: setup prove
	@echo "✓ All done."

help:
	@echo "━━━ age-zkp Makefile ━━━"
	@echo "  make              setup + prove (full pipeline)"
	@echo "  make setup        one-time: compile + ptau + phase2"
	@echo "  make prove        use age from input.json"
	@echo "  make prove AGE=N  set age to N and prove"
	@echo "  make verify       re-check existing proof"
	@echo "  make clean        remove build artifacts"
	@echo "  make reset        clean + remove node_modules"
	@echo ""
	@echo "Current age in input.json: $(CURRENT_AGE)"

# ── One-time setup (run when circuit changes) ─────────────────

setup: compile ptau phase2
	@echo "✓ Setup complete.  Now run:  make prove   or   make prove AGE=42"

compile: $(BUILD)/age_verification.r1cs
ptau:   $(BUILD)/pot12_final.ptau
phase2: $(BUILD)/verification_key.json

$(BUILD)/age_verification.r1cs: age_verification.circom node_modules
	bash $(SCRIPTS)/01_compile.sh

$(BUILD)/pot12_final.ptau: $(BUILD)/age_verification.r1cs
	bash $(SCRIPTS)/02_ptau.sh

$(BUILD)/verification_key.json: $(BUILD)/pot12_final.ptau
	bash $(SCRIPTS)/03_setup.sh

# ── Fast path ─────────────────────────────────────────────────
#   make prove          → uses the age in input.json
#   make prove AGE=30   → sets age to 30, then runs the full pipeline

prove: $(BUILD)/verification_key.json
ifeq ($(AGE),)
	@echo "━━━ Proving age > 18 (age = $(CURRENT_AGE)) ━━━"
else
	@python3 -c "import json; d=json.load(open('input.json')); d['age']='$(AGE)'; json.dump(d, open('input.json','w'), indent=2)"
	@echo "━━━ Age set to $(AGE). Proving age > 18 ━━━"
endif
	node compute_commitment.js
	bash $(SCRIPTS)/04_witness.sh
	bash $(SCRIPTS)/05_prove.sh
	bash $(SCRIPTS)/06_verify.sh
	@echo ""
	@echo "  ┌──────────────────────────────────────────────┐"
	@echo "  │  [OK]  snarkJS: OK!                          │"
	@echo "  └──────────────────────────────────────────────┘"

# ── Utilities ─────────────────────────────────────────────────

verify:
	@bash $(SCRIPTS)/06_verify.sh

clean:
	rm -rf $(BUILD)/*.ptau $(BUILD)/*.zkey $(BUILD)/*.r1cs $(BUILD)/*.sym
	rm -rf $(BUILD)/*.json $(BUILD)/*.wtns
	rm -rf $(BUILD)/age_verification_js/

reset: clean
	rm -rf node_modules

node_modules: package.json
	@npm install
	@touch node_modules
