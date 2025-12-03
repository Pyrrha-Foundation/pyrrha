# Pyrrha Development Phases

This document tracks the staged rollout for Pyrrha. Phase 1 is currently underway.

## Phase 1 — Rebrand & Chain Constants (Current)
- Rename identifiers, messages, and defaults to the Pyrrha brand and PYRR ticker
- Define network ports, magic bytes, and coin display precision for new networks
- Clear inherited DNS seeds and checkpoints pending Pyrrha-native infrastructure
- Draft the emission schedule and reward curve for the new chain
- Prepare the build system and documentation for custom genesis generation

## Phase 2 — Genesis & Devnet Launch
- Calculate mainnet and testnet genesis blocks
- Enable a private devnet/regtest mode for experimentation
- Stand up a small local network to validate syncing, mining, and mempool behavior

## Phase 3 — PoW Algorithm Upgrade
- Integrate the fully ASIC-resistant PoW, optimized for CPU/GPU parity
- Publish Pyrrha Miner reference implementation and pool/solo mining docs

## Phase 4 — Core Protocol Enhancements
- UTXO-native token and scripting improvements
- Enhanced unconfirmed-chain handling and mempool policies
- Privacy and performance optimizations

## Phase 5 — Ecosystem Expansion
- Public testnet, updated explorer, and wallet integrations
- Community grants and developer onboarding

## Phase 6 — Mainnet Hardening
- Final emission tuning and governance discussions
- Community seed nodes, audits, and release candidates
