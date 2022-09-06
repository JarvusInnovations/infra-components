required_missing=()

test "$ENGINE_ROOT"           || { printf 'FATAL BUG: ENGINE_ROOT is not defined!\n'  >&2; exit 1; }
test "$CONTENT_ROOT"          || { printf 'FATAL BUG: CONTENT_ROOT is not defined!\n' >&2; exit 1; }
test "$INFRA_DEPLOYMENT_NAME" || required_missing+=('INFRA_DEPLOYMENT_NAME')
test "$INFRA_TARGET_NAME"     || required_missing+=('INFRA_TARGET_NAME')

. "$ENGINE_ROOT"/lib/sh/validate-required.sh

INFRA_DEPLOYMENT_ENDPOINT=$CONTENT_ROOT/terraform/deployments/$INFRA_DEPLOYMENT_NAME
INFRA_TARGET_ENDPOINT=$CONTENT_ROOT/terraform/targets/$INFRA_TARGET_NAME/$INFRA_DEPLOYMENT_NAME

TERRAFORM=('terraform' "-chdir=$INFRA_DEPLOYMENT_ENDPOINT")

if [[ ! -e $INFRA_DEPLOYMENT_ENDPOINT/.terraform ]]; then
  "${TERRAFORM[@]}" init -backend-config="$INFRA_TARGET_ENDPOINT/target.tfbackend"
fi
