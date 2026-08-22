const { buildPoseidon } = require("circomlibjs");
const fs = require("fs");

async function main() {
    // Read age and salt from input.json (the single source of truth)
    const raw = JSON.parse(fs.readFileSync("input.json", "utf8"));
    const age = BigInt(raw.age);
    const salt = BigInt(raw.salt);

    const poseidon = await buildPoseidon();
    const hash = poseidon([age, salt]);
    const commitment = poseidon.F.toString(hash);

    raw.commitment = commitment;
    fs.writeFileSync("input.json", JSON.stringify(raw, null, 2));
    console.log("input.json updated with commitment:");
    console.log(JSON.stringify(raw, null, 2));
}

main().catch(console.error);
