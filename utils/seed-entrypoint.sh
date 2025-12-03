#!/usr/bin/env bash
set -euo pipefail

DATA_DIR=/home/pyrrha/.pyrrha
WALLET_FILE="$DATA_DIR/miner-wallet"
ADDRESS_FILE="$DATA_DIR/miner-address.txt"
LOG_FILE="$DATA_DIR/miner-wallet.log"

mkdir -p "$DATA_DIR"

if [ ! -s "$ADDRESS_FILE" ]; then
  echo "[seed-entrypoint] Generating new miner wallet and address..."
  # Create a new wallet and capture the address line. The wallet is left empty; no password is set for local dev.
  pyrrha-wallet-cli \
    --generate-new-wallet "$WALLET_FILE" \
    --password "" \
    --mnemonic-language English \
    --command address >"$LOG_FILE" 2>&1

  ADDRESS=$(grep -m1 '^Address' "$LOG_FILE" | awk '{print $2}')
  if [ -z "${ADDRESS:-}" ]; then
    echo "[seed-entrypoint] Failed to derive address; check $LOG_FILE for details" >&2
    exit 1
  fi

  echo "$ADDRESS" >"$ADDRESS_FILE"
  echo "[seed-entrypoint] Miner address generated: $ADDRESS"
else
  ADDRESS=$(cat "$ADDRESS_FILE")
  echo "[seed-entrypoint] Reusing existing miner address: $ADDRESS"
fi

exec pyrrhad \
  --data-dir="$DATA_DIR" \
  --p2p-bind-ip=0.0.0.0 \
  --p2p-bind-port=21090 \
  --rpc-bind-ip=0.0.0.0 \
  --rpc-bind-port=21091 \
  --zmq-rpc-bind-ip=0.0.0.0 \
  --zmq-rpc-bind-port=21092 \
  --confirm-external-bind \
  --non-interactive \
  --prune-blockchain \
  --fixed-difficulty=1 \
  --start-mining="$ADDRESS" \
  --mining-threads=1 \
  --enable-dns-blocklist=0 \
  --add-priority-node=pyrrha-peer-1:30090 \
  --add-priority-node=pyrrha-peer-2:40090 \
  --add-priority-node=pyrrha-peer-3:50090
