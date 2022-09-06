#!/bin/bash
set -e

SCRIPT=$(basename "$0")
PROJECT_ROOT=$(realpath "$(dirname "$0")"/..)
COMPONENT_NAME=$1
COMPONENT_VERSION=$2
RELEASE_CHANNEL=$3

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

# Version numbers:
# * May start with a lowercase letter
# * Leading letter may be followed by - or .
# * First - or . must be followed by a digit
# * Any amount of subsequent digits may be added, any of which may be prefixed with - or .
# * Any - or . after the first may be followed by a lowecase letter
if ! [[ $COMPONENT_VERSION =~ ^([a-z][-.]?)?[0-9](([-.][a-z])?([-.]?[0-9])*)*$ ]]; then
  printf '%s: fatal: invalid version specifier: %s\n' "$SCRIPT" "$COMPONENT_VERSION"
  exit 1
fi

#
# Publish
#

PUBLISH_REV=$(git subtree split -P "$COMPONENT_PATH")
PUBLISH_TAG=$COMPONENT_NAME/$COMPONENT_VERSION
PUBLISH_BRANCH=channels/$COMPONENT_NAME/$RELEASE_CHANNEL
LAST_RELEASE=$(git describe --abbrev=0 --always "$PUBLISH_REV")

if [[ $LAST_RELEASE =~ [a-f0-9]{40} ]]; then
  printf '%s: info: first release: %s: %s\n' "$SCRIPT" "$COMPONENT_NAME" "$COMPONENT_VERSION"
  RELEASE_CHANGELOG=$(git shortlog "$PUBLISH_REV")
else
  printf '%s: info: new release: %s: %s -> %s\n' "$SCRIPT" "$COMPONENT_NAME" "$(basename "$LAST_RELEASE")" "$COMPONENT_VERSION"
  RELEASE_CHANGELOG=$(git shortlog "$LAST_RELEASE".."$PUBLISH_REV")
fi

git tag -m "$RELEASE_CHANGELOG" "$PUBLISH_TAG" "$PUBLISH_REV"

if [[ $RELEASE_CHANNEL ]]; then
  git update-ref -m "release $PUBLISH_TAG" refs/heads/"$PUBLISH_BRANCH" "$PUBLISH_REV"
fi

if [[ $PUBLISH_REMOTE ]]; then
  git push "$PUBLISH_REMOTE" "$PUBLISH_TAG"

  if [[ $RELEASE_CHANNEL ]]; then
    printf '%s: info: publication channel: %s -> %s\n' "$SCRIPT" "$RELEASE_CHANNEL" "$COMPONENT_VERSION"
    git push "$PUBLISH_REMOTE" "$PUBLISH_BRANCH"
  fi

else
  printf '%s: notice: no PUBLISH_REMOTE configured; skipping tag push\n' "$SCRIPT"
fi
