# terraform-report
#
# orchestrate the reporting of all terraform targets with pending changes
# constructs an associative array of {endpoint}={changes} items named
# target_endpoint_changes

required_missing=()

test "$ENGINE_ROOT"       || { printf 'FATAL BUG: ENGINE_ROOT is not defined!\n'  >&2; exit 1; }
test "$CONTENT_ROOT"      || { printf 'FATAL BUG: CONTENT_ROOT is not defined!\n' >&2; exit 1; }
test "$INFRA_TARGET_NAME" || required_missing+=('INFRA_TARGET_NAME')

ENGINE_ROOT=$(realpath "$ENGINE_ROOT")
CONTENT_ROOT=$(realpath "$CONTENT_ROOT")

. "$ENGINE_ROOT"/lib/sh/validate-required.sh

declare -A target_endpoint_changes
export INFRA_TARGET_NAME

if [[ $(pwd) != $CONTENT_ROOT ]]; then
  cd "$CONTENT_ROOT"
fi

INFRA_ENV_ROOT=terraform/targets/$INFRA_TARGET_NAME

if [[ ! -e $INFRA_ENV_ROOT ]]; then
  printf 'terraform-report: warn: no target environment: %s; skipping report\n' "$INFRA_TARGET_NAME" >&2
  return 0
fi

for endpoint in "$INFRA_ENV_ROOT"/*; do

  test ! -f "$endpoint" || continue

  unset  INFRA_DEPLOYMENT_NAME
  export INFRA_DEPLOYMENT_NAME=$(basename "$endpoint")

  # run terraform-init ahead of time
  # to avoid capturing output in map
  . "$ENGINE_ROOT"/lib/sh/terraform-setup.sh

  set +e
  changes=$($ENGINE_ROOT/drivers/terraform-changed -no-color)
  rc=$?
  set -e

  case $rc in
    0)
      printf 'terraform-report: target=%s, deployment=%s: unchanged\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME"
      continue
    ;;
    1)
      printf 'terraform-report: target=%s, deployment=%s: reporting changes\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME"
      target_endpoint_changes[$endpoint]=$changes
    ;;
    *)
      printf 'fatal: terraform-report: target=%s, deployment=%s: terraform-desired exited with error\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME" >&2
      exit 1
    ;;
  esac

done
