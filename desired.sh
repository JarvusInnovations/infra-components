#!/bin/bash
set -e

INFRA_ROOT=$(realpath "$(dirname "$0")"/../..)

. "$INFRA_ROOT"/Sh/terraform-setup.sh

set +e
"${TERRAFORM[@]}" plan -detailed-exitcode -var-file="$INFRA_TARGET_ENDPOINT/target.tfvars"
rc=$?
set -e

case $rc in
  0) exit 0;;
  1) exit 2;;
  2) exit 1;;
esac
