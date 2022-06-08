# terraform-report
#
# orchestrate the reporting of all terraform targets with pending changes
# constructs an associative array of {endpoint}={changes} items named
# target_endpoint_changes

required_missing=()

test "$INFRA_ROOT"        || { printf 'FATAL BUG: INFRA_ROOT is not defined!\n' >&2; exit 1; }
test "$INFRA_TARGET_NAME" || required_missing+=('INFRA_TARGET_NAME')

. "$INFRA_ROOT"/Sh/validate-required.sh

declare -A target_endpoint_changes
export INFRA_TARGET_NAME

if [[ $(pwd) != $INFRA_ROOT ]]; then
  cd "$INFRA_ROOT"
fi

for endpoint in targets/terraform/"$INFRA_TARGET_NAME"/*; do

  unset  INFRA_DEPLOYMENT_NAME
  export INFRA_DEPLOYMENT_NAME=$(basename "$endpoint")

  # run terraform-init ahead of time
  # to avoid capturing output in map
  . "$INFRA_ROOT"/Sh/terraform-setup.sh

  set +e
  changes=$($INFRA_ROOT/procedures/terraform/desired.sh -no-color)
  rc=$?
  set -e

  case $rc in
    0)
      printf 'terraform-release: target=%s, deployment=%s: unchanged\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME"
      continue
    ;;
    1)
      printf 'terraform-release: target=%s, deployment=%s: reporting changes\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME"
      target_endpoint_changes[$endpoint]=$changes
    ;;
    *)
      printf 'fatal: terraform-release: target=%s, deployment=%s: terraform-desired exited with error\n' "$INFRA_TARGET_NAME" "$INFRA_DEPLOYMENT_NAME" >&2
      exit 1
    ;;
  esac

done
