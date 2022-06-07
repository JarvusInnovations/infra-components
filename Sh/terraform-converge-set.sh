
required_missing=()

test "$INFRA_ROOT"        || { printf 'fatal: INFRA_ROOT is not defined!\n' >&2; exit 1; }
test "$INFRA_TARGET_NAME" || required_missing+=('INFRA_TARGET_NAME')

. "$INFRA_ROOT"/Sh/validate-required.sh

export INFRA_TARGET_NAME

for deployment_name in "${!deployments_set[@]}"; do
  unset  INFRA_DEPLOYMENT_NAME
  export INFRA_DEPLOYMENT_NAME=$deployment_name
  printf 'info: terraform-converge: deployment=%s, target=%s\n' "$INFRA_DEPLOYMENT_NAME" "$INFRA_TARGET_NAME"
  "$INFRA_ROOT/procedures/terraform-converge.sh"
done
