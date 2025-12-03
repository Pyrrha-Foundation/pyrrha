# Pyrrha — A Human-First Proof-of-Work Blockchain

Pyrrha is a next-generation Proof-of-Work blockchain designed to restore mining fairness for everyday people—not industrial ASIC farms. Derived from a mature UTXO-based codebase, Pyrrha evolves significantly in identity, emission, consensus tuning, and a devnet-first approach for experimentation.

*Post-ASIC. Post-Farm. Proof-of-Work reborn for real people.*

## Vision and Mythology

Pyrrha takes its name from Greek mythology: after the great flood, Pyrrha and Deucalion repopulated the world by throwing stones behind them—each stone becoming a human. That spirit mirrors Pyrrha’s mission:

- **ASIC farms =** the flood that drowned fair PoW
- **Home miners =** the stones that repopulate a decentralized network
- **Pyrrha =** Proof-of-Work rebuilt for real people

## Chain Identity

- **Network / Coin Name:** Pyrrha
- **Ticker:** PYRR
- **Model:** UTXO
- **Consensus:** ASIC-resistant Proof-of-Work (CPU + GPU friendly)
- **Mission:** Rebuild PoW mining for ordinary hardware
- **Status:** Early development (Phase 1 → Phase 2)

## Tokenomics (Phase 1 baselines)

**Proof-of-Work Algorithm**
- ASIC-resistant, memory-hard, and tuned for CPU/GPU parity.
- CPU/GPU friendly today, with room for a future hybrid PoW variant if research supports it.

**Emission Model**
- Fair launch: **0 premine** and **0% dev tax**.
- High initial block reward to reward early network builders.
- Block reward reductions on a predictable cadence, converging to a tail emission to keep miners incentivized over the long run.

**Block Parameters**
- Target block time: ~60 seconds.
- Dynamic block size that automatically adapts to network usage rather than staying fixed.
- Uncapped supply with controlled inflation via the emission schedule above.

## Development Phases

1. **Phase 1 — Rebrand & Chain Constants (current)**
   - Rename identifiers to Pyrrha and update chain constants, ports, and tickers
   - Cleanse seeds and checkpoints and prepare emission schedule
   - Document build system updates and genesis preparation steps
2. **Phase 2 — Genesis & Devnet Launch**
   - Compute new mainnet/testnet genesis blocks
   - Enable a private devnet/regtest and launch a local multi-node network
3. **Phase 3 — PoW Algorithm Upgrade**
   - Integrate the fully ASIC-resistant PoW and optimize for CPU/GPU parity
4. **Phase 4 — Core Protocol Enhancements**
   - UTXO-native tokens, streamlined scripting, and mempool improvements
5. **Phase 5 — Ecosystem Expansion**
   - Public testnet, explorer and wallet integrations, and community grants
6. **Phase 6 — Mainnet Hardening**
   - Final emission tuning, governance discussions, seed nodes, and audits

## Building Pyrrha

Pyrrha inherits the proven build system of its upstream codebase. Platform-specific notes live under `docs/`:

- `docs/COMPILING_DEBUGGING_TESTING.md` for build and test guidance
- `docs/RELEASE_CHECKLIST.md` and `docs/CONTRIBUTING.md` for release and contribution guidelines

## Running Pyrrha Nodes

Operational documentation will be refreshed during Phase 2 alongside the devnet launch. Existing Monero operational docs under `docs/` remain a useful reference until the Pyrrha-specific runbooks are complete.

### Local 4-node devnet via Docker Compose

For a quick connectivity smoke test, a four-node Compose topology is included:

1. Launch the network: `docker compose up --build`.
2. Wait for the health checks to report `healthy`, then query any node for status, e.g. `curl -d '{"jsonrpc":"2.0","id":"0","method":"get_info"}' -H 'Content-Type: application/json' http://localhost:21091/json_rpc`.

The seed node now mints a dedicated devnet wallet and saves the miner address to `./data/node-seed/miner-address.txt` on first boot. That address is re-used on subsequent runs, keeping mining rewards persistent across restarts. Each peer pins to the seed plus the other peers to validate gossip and block propagation. Data directories land under `./data/node-*` so you can wipe and restart cleanly if you want to regenerate the wallet.

## License

Pyrrha is released under the MIT License. See `LICENSE` for details. Portions originate from the Monero and original Cryptonote projects.
