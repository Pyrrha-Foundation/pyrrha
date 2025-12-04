#!/usr/bin/env bash
set -euo pipefail

DATA_DIR=/home/pyrrha/.pyrrha
WALLET_FILE="$DATA_DIR/miner-wallet"
ADDRESS_FILE="$DATA_DIR/miner-address.txt"
LOG_FILE="$DATA_DIR/miner-wallet.log"

# If we're running as root (common when the host bind-mount is owned by root),
# ensure the data directory is writable and drop privileges to the pyrrha user
# before continuing.
if [[ "${SEED_ENTRYPOINT_AS_PYRRHA:-0}" != "1" && $(id -u) -eq 0 ]]; then
  mkdir -p "$DATA_DIR"
  chown -R pyrrha:pyrrha "$DATA_DIR"
  exec su -s /bin/bash pyrrha -c "SEED_ENTRYPOINT_AS_PYRRHA=1 DATA_DIR=$DATA_DIR WALLET_FILE=$WALLET_FILE ADDRESS_FILE=$ADDRESS_FILE LOG_FILE=$LOG_FILE /usr/local/bin/seed-entrypoint.sh"
fi

mkdir -p "$DATA_DIR"

if [ ! -s "$ADDRESS_FILE" ]; then
  echo "[seed-entrypoint] Generating new miner wallet and address..."
  # Create a new wallet and capture the address line. The wallet is left empty; no password is set for local dev.
  if ! pyrrha-wallet-cli \
    --generate-new-wallet "$WALLET_FILE" \
    --password "" \
    --mnemonic-language English \
    --command address >"$LOG_FILE" 2>&1; then
    echo "[seed-entrypoint] Wallet creation failed; contents of $LOG_FILE:" >&2
    cat "$LOG_FILE" >&2
    exit 1
  fi

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
  --add-priority-node=pyrrha-peer-1:30090 \
  --add-priority-node=pyrrha-peer-2:40090 \
  --add-priority-node=pyrrha-peer-3:50090
