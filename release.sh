#!/bin/bash
set -e

INFRA_ROOT=$(realpath "$(dirname "$0")"/../..)

required_missing=()

test "$INFRA_TARGET_NAME" || required_missing+=('INFRA_TARGET_NAME')

. "$INFRA_ROOT"/Sh/validate-required.sh

export INFRA_TARGET_NAME

for endpoint in "$INFRA_ROOT"/targets/terraform/"$INFRA_TARGET_NAME"/*; do

  unset  INFRA_DEPLOYMENT_NAME
  export INFRA_DEPLOYMENT_NAME=$(basename "$endpoint")

  set +e
  $INFRA_ROOT/procedures/terraform/desired.sh
  rc=$?
  set -e

  case $rc in
    0)
      printf 'terraform-release: target=%s, deployment=%s: unchanged\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME"
      continue
    ;;
    1)
      printf 'terraform-release: target=%s, deployment=%s: converging\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME"
      "$INFRA_ROOT/procedures/terraform/converge.sh"
    ;;
    *)
      printf 'fatal: terraform-release: target=%s, deployment=%s: terraform-desired exited with error\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME" >&2
      exit 1
    ;;
  esac

done
