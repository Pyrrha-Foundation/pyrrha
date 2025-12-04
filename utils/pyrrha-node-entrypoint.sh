#!/usr/bin/env bash
set -euo pipefail

DATA_DIR=${PYRRHA_DATA_DIR:-/home/pyrrha/.pyrrha}

if [[ "${PYRRHA_CHILD:-0}" != "1" && $(id -u) -eq 0 ]]; then
  mkdir -p "$DATA_DIR"
  chown -R pyrrha:pyrrha "$DATA_DIR"

  # Drop privileges using runuser (preferred) to avoid shell option parsing issues
  # when the node command includes flags starting with "--". Fall back to su if
  # runuser is unavailable in the environment.
  if command -v runuser >/dev/null 2>&1; then
    exec runuser -u pyrrha -- env PYRRHA_CHILD=1 PYRRHA_DATA_DIR="$DATA_DIR" "$0" "$@"
  else
    # su expects options before the username; place -c before pyrrha so flags in
    # "$@" are not treated as su options (which caused failures like
    # "su: unrecognized option '--data-dir=...'" when runuser was unavailable).
    exec su -s /bin/bash -c "PYRRHA_CHILD=1 PYRRHA_DATA_DIR=$DATA_DIR \"$0\" \"$@\"" pyrrha
  fi
fi

exec "$@"
