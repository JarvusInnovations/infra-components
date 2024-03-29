#!/bin/bash

PR_TITLE=$(jq -r ".pull_request.title" "${GITHUB_EVENT_PATH}")

# check title format and extract tag
if [[ "${PR_TITLE}" =~ ^Release:\ v[0-9]+\.[0-9]+\.[0-9]+(-rc\.[0-9]+)?$ ]]; then
    RELEASE_TAG="${PR_TITLE:9}"
    echo "RELEASE_TAG=${RELEASE_TAG}" >> "${GITHUB_ENV}"
else
    echo 'PR title must match format "Release: vX.Y.Z(-rc.#)?"'
    exit 1
fi

# check that tag doesn't exist
if git ls-remote --exit-code "https://${GITHUB_ACTOR}:${GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}" "refs/tags/${RELEASE_TAG}"; then
    echo "The PR title's version exists already"
    exit 1
fi
