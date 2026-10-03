#!/usr/bin/env bash
set -euo pipefail
environment="${1:?Usage: deploy.sh dev|stage|prod image}"
image="${2:?Supply an immutable image tag}"
case "$environment" in dev|stage|prod) ;; *) exit 2 ;; esac
terraform -chdir="terraform/environments/$environment" init -input=false
terraform -chdir="terraform/environments/$environment" apply -input=false -auto-approve -var="image=$image"
