pragma circom 2.0.0;

include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/comparators.circom";

template AgeRangeProof(min_age, max_age_bits) {
    // Public inputs
    signal input commitment;   // Poseidon(age, salt)
    // Private inputs
    signal input age;
    signal input salt;
    // Public output
    signal output valid;

    // (A) Enforce: Poseidon(age, salt) == commitment
    component hash = Poseidon(2);
    hash.inputs[0] <== age;
    hash.inputs[1] <== salt;
    hash.out === commitment;

    // (B) Enforce: age >= min_age  ⟺  not (age < min_age)
    component lt = LessThan(max_age_bits);
    lt.in[0] <== age;
    lt.in[1] <== min_age;
    valid <== 1 - lt.out;
}

component main {public [commitment]} = AgeRangeProof(18, 8);
