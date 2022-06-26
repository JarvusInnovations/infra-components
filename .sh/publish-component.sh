#!/bin/bash
set -e

SCRIPT=$(basename "$0")
PROJECT_ROOT=$(realpath "$(dirname "$0")"/..)
COMPONENT_NAME=$1
COMPONENT_VERSION=$2

#
# Validate
#

COMPONENT_PATH=

# NOTE: git-subtree-split will fail on absolute paths, so COMPONENT_PATH must
# be relative ro PROJECT_ROOT
test ! -d "$PROJECT_ROOT/$COMPONENT_NAME"             || COMPONENT_PATH=$COMPONENT_NAME
test ! -d "$PROJECT_ROOT/deployments/$COMPONENT_NAME" || COMPONENT_PATH=deployments/$COMPONENT_NAME
test "$PUBLISH_REMOTE"                                || PUBLISH_REMOTE=$(git config --get --default '' publish.remote)

if ! [[ $COMPONENT_PATH ]]; then
  printf '%s: fatal: component not found: %s\n' "$SCRIPT" "$COMPONENT_NAME" >&2
  exit 1
fi

if ! [[ $COMPONENT_VERSION =~ ^v[0-9]+\.[0-9]+\.[0-9]+ ]]; then
  printf '%s: fatal: invalid version specifier: %s\n' "$SCRIPT" "$COMPONENT_VERSION"
  exit 1
fi

#
# Publish
#

PUBLISH_REV=$(git subtree split -P "$COMPONENT_PATH")
PUBLISH_TAG=$COMPONENT_NAME/$COMPONENT_VERSION
LAST_RELEASE=$(git describe --abbrev=0 --always "$PUBLISH_REV")

if [[ $LAST_RELEASE =~ [a-f0-9]{40} ]]; then
  printf '%s: info: first release: %s: %s\n' "$SCRIPT" "$COMPONENT_NAME" "$COMPONENT_VERSION"
  RELEASE_CHANGELOG=$(git shortlog "$PUBLISH_REV")
else
  printf '%s: info: new release: %s: %s -> %s\n' "$SCRIPT" "$COMPONENT_NAME" "$(basename "$LAST_RELEASE")" "$COMPONENT_VERSION"
  RELEASE_CHANGELOG=$(git shortlog "$LAST_RELEASE".."$PUBLISH_REV")
fi

git tag -m "$RELEASE_CHANGELOG" "$PUBLISH_TAG" "$PUBLISH_REV"

if [[ $PUBLISH_REMOTE ]]; then
  git push "$PUBLISH_REMOTE" "$PUBLISH_TAG"
else
  printf '%s: notice: no PUBLISH_REMOTE configured; skipping tag push\n' "$SCRIPT"
fi
