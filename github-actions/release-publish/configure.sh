#!/bin/bash

PR_TITLE=$(jq -r ".pull_request.title" "${GITHUB_EVENT_PATH}")
PR_BODY=$(jq -r ".pull_request.body" "${GITHUB_EVENT_PATH}")
RELEASE_TAG=$(echo "${PR_TITLE}" | grep -oP "(?<=^Release: )v\d+\.\d+\.\d+(-rc\.\d+)?$")

if [[ "${RELEASE_TAG}" =~ -rc\.[0-9]+$ ]]; then
    RELEASE_PRERELEASE=true
else
    RELEASE_PRERELEASE=false
fi

{
    echo "release-tag=${RELEASE_TAG}"
    echo "release-prerelease=${RELEASE_PRERELEASE}"

    echo 'release-body<<END_OF_BODY'
    echo "${PR_BODY}"
    echo 'END_OF_BODY'
} >> "${GITHUB_OUTPUT}"
