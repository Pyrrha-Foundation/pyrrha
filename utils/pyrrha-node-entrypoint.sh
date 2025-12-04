#!/usr/bin/env bash
set -euo pipefail

DATA_DIR=${PYRRHA_DATA_DIR:-/home/pyrrha/.pyrrha}

if [[ "${PYRRHA_CHILD:-0}" != "1" && $(id -u) -eq 0 ]]; then
  mkdir -p "$DATA_DIR"
  chown -R pyrrha:pyrrha "$DATA_DIR"
  exec su -s /bin/bash pyrrha -c "PYRRHA_CHILD=1 PYRRHA_DATA_DIR=$DATA_DIR \"$0\" \"$@\""
fi

exec "$@"
