required_missing=()

test "$INFRA_ROOT"            || { printf 'FATAL BUG: INFRA_ROOT is not defined!\n' >&2; exit 1; }
test "$INFRA_DEPLOYMENT_NAME" || required_missing+=('INFRA_DEPLOYMENT_NAME')
test "$INFRA_TARGET_NAME"     || required_missing+=('INFRA_TARGET_NAME')

. "$INFRA_ROOT"/Sh/validate-required.sh

INFRA_DEPLOYMENT_ENDPOINT=$INFRA_ROOT/deployments/terraform/$INFRA_DEPLOYMENT_NAME
INFRA_TARGET_ENDPOINT=$INFRA_ROOT/targets/terraform/$INFRA_TARGET_NAME/$INFRA_DEPLOYMENT_NAME

TERRAFORM=('terraform' "-chdir=$INFRA_DEPLOYMENT_ENDPOINT")

if [[ ! -e $INFRA_DEPLOYMENT_ENDPOINT/.terraform ]]; then
  "${TERRAFORM[@]}" init -backend-config="$INFRA_TARGET_ENDPOINT/target.tfbackend"
fi
