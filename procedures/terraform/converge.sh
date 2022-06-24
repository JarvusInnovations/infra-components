#!/bin/bash
set -e

INFRA_ROOT=$(realpath "$(dirname "$0")"/../..)

. "$INFRA_ROOT"/Sh/terraform-setup.sh

exec "${TERRAFORM[@]}" apply -auto-approve -var-file="$INFRA_TARGET_ENDPOINT/target.tfvars"
