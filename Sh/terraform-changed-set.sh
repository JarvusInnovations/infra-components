
required_missing=()

test "$INFRA_ROOT"        || { printf 'fatal: INFRA_ROOT is not defined!\n' >&2; exit 1; }
test "$INFRA_TARGET_NAME" || required_missing+=('INFRA_TARGET_NAME')
test "$INFRA_REV_BASE"    || required_missing+=('INFRA_REV_BASE')
test "$INFRA_REV_HEAD"    || required_missing+=('INFRA_REV_HEAD')

. "$INFRA_ROOT"/Sh/validate-required.sh

declare -A deployments_set

while read pathname; do
  if   [[ $pathname =~ ^targets/terraform/$INFRA_TARGET_NAME ]]; then
    endpoint=$(cut -d/ -f-4 <<< "$pathname")
  elif [[ $pathname =~ ^deployments/terraform ]]; then
    endpoint=$(cut -d/ -f-3 <<< "$pathname")
  else
    printf 'warn: unprocessed changed path: %s\n' "$pathname" >&2
    continue
  fi
  deployment_name=$(basename "$endpoint")
  deployments_set[$deployment_name]=1
done <<< "$(git -C "$INFRA_ROOT" diff --name-only "$INFRA_REV_BASE" "$INFRA_REV_HEAD"  -- "targets/terraform/$INFRA_TARGET_NAME" deployments/terraform)"
