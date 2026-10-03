#!/usr/bin/env bash
set -euo pipefail
environment="${1:?Usage: rollback.sh dev|stage|prod previous-image}"
previous_image="${2:?Provide the previously tested immutable image}"
bash scripts/deploy.sh "$environment" "$previous_image"
case "$environment" in dev) port=8081 ;; stage) port=8082 ;; prod) port=8083 ;; *) exit 2 ;; esac
python3 scripts/smoke.py "http://127.0.0.1:$port"
