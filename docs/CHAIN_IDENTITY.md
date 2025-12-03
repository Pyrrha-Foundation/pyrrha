# Pyrrha Chain Identity and Early Constants

This document captures the initial identity decisions and placeholders for Pyrrha while Phase 1 rebranding work proceeds.

## Identity
- **Network / Coin Name:** Pyrrha
- **Ticker:** PYRR
- **Model:** UTXO
- **Consensus:** ASIC-resistant Proof-of-Work (CPU/GPU friendly)

## Proposed Network Constants (Draft)
- **Target block time:** 60 seconds
- **Display precision:** 12 decimal places (Cryptonote-compatible)
- **Default p2p/rpc ports:** Mainnet 21090/21091/21092, Testnet 31090/31091/31092, Stagenet 41090/41091/41092
- **Base58 prefixes:** Mainnet 22/23/24, Testnet 73/74/75, Stagenet 78/79/80
- **Network IDs:** Distinct Pyrrha UUIDs for mainnet/testnet/stagenet
- **Emission curve:** Fair launch (0 premine, 0% dev tax), high initial reward, predictable reductions, and a sustaining tail emission
- **Dynamic block size:** Enabled, tuned for usage-responsive scaling
- **Genesis coinbase notes:**
  - Mainnet: `Pyrrha genesis: Pebbles > ASICs`
  - Testnet: `Pyrrha test genesis: rocks of QA`
  - Stagenet: `Pyrrha stage genesis: rehearsals matter`

## Next Steps
- Replace inherited seeds, checkpoints, and magic bytes with Pyrrha-specific values
- Finalize p2p/rpc port map for mainnet, testnet, and devnet
- Publish the emission schedule and reward formula
- Wire genesis block calculation utilities into the build/documentation flow
