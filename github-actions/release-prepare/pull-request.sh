#!/bin/bash


# get latest release tag
# When RELEASE_TAG_MATCH is set, only tags matching that glob are considered, so
# a repo with multiple prefix-namespaced tag tracks sharing one git tag space
# (e.g. `v*` for a JS package plus `foo-v*` for a native binding) computes the
# next version from its own track rather than whatever tag is topologically
# nearest. A no-match (a brand-new track) falls through to the v0.1.0 default.
echo "Looking for last tag..."
if [ -n "${RELEASE_TAG_MATCH}" ]; then
    echo "Restricting to tags matching: ${RELEASE_TAG_MATCH}"
    latest_release=$(git describe --tags --abbrev=0 --match "${RELEASE_TAG_MATCH}" "origin/${RELEASE_BRANCH}" 2>/dev/null || true)
else
    latest_release=$(git describe --tags --abbrev=0 "origin/${RELEASE_BRANCH}" 2>/dev/null || true)
fi


# generate next patch release tag
if [ -n "${latest_release}" ]; then
    echo "Found tag: ${latest_release}"
    latest_release_bumped=$(echo "${latest_release}" | awk -F. -v OFS=. '{$NF++;print}')
else
    echo "No tag found, defaulting to v0.1.0"
    latest_release_bumped='v0.1.0'
fi


# prepare PR text
pr_title="Release: ${latest_release_bumped}"
if [ -f .github/release-pr-template.md ]; then
  echo "Using custom PR template"
  pr_body="$(cat ".github/release-pr-template.md")"
else
  echo "Using default PR template"
  pr_body="$(cat "${GITHUB_ACTION_PATH}/release-pr-template.md")"
fi


# create or update PR
echo "Looking for existing PR..."
pr_number=$(
    gh pr view "${GITHUB_REF_NAME}" \
        --json number,state \
        --template '{{.number}}{{"\t"}}{{.state}}' \
    | grep OPEN \
    | awk '{print $1}'
)

if [ -n "${pr_number}" ]; then
    echo "Found existing PR #${pr_number}, looking for existing comment..."

    # If two release-prepare runs raced (e.g. two PRs merged within seconds), each
    # may have created its own changelog comment. Keep the oldest match and delete
    # any extras so we have exactly one comment to update from here on.
    existing_comment_id=""
    while IFS= read -r comment_id; do
        if [ -z "${existing_comment_id}" ]; then
            existing_comment_id="${comment_id}"
        else
            echo "Deleting duplicate changelog comment #${comment_id}"
            gh api -X DELETE "/repos/${GITHUB_REPOSITORY}/issues/comments/${comment_id}"
        fi
    done < <(
        gh api "/repos/${GITHUB_REPOSITORY}/issues/${pr_number}/comments" \
            --jq '[.[] | select(.body | startswith("## Changelog\n\n"))] | sort_by(.created_at) | .[].id'
    )
else
    echo "Opening PR..."
    pr_url=$(
        gh pr create \
            --base "${RELEASE_BRANCH}" \
            --head "${GITHUB_REF_NAME}" \
            --title "${pr_title}" \
            --body "${pr_body}"
    )
    pr_number="${pr_url##*/}"
    echo "Opened PR #${pr_number}"
fi


# build changelog
echo "Getting list of commits in range ${RELEASE_BRANCH}..${GITHUB_REF_NAME}..."
commits=$(
    git log \
    --first-parent \
    --reverse \
    --format="%H" \
    "origin/${RELEASE_BRANCH}..${GITHUB_REF_NAME}"
)

changelog=()

echo "Generating changelog lines..."
while read -r commit; do
    subject="$(git show -s --format=%s "${commit}")"
    line=""

    if [[ "${subject}" =~ Merge\ pull\ request\ \#([0-9]+) ]]; then
        line="$(gh pr view "${BASH_REMATCH[1]}" --json title,number,author --template '{{.title}} [#{{.number}}] @{{.author.login}}' || true)"
    fi

    if [ -z "${line}" ]; then
        author="$(gh api "/repos/${GITHUB_REPOSITORY}/commits/${commit}" | jq -r '.author.login')"
        if [ -n "${author}" ]; then
            author="@${author}"
        else
            author="$(git show -s --format=%ae "${commit}")"
        fi

        line="${subject} ${author}"
    fi

    # move ticket number prefix into to existing square brackets at end
    line="$(echo "${line}" | perl -pe 's/^([A-Z]+-[0-9]+):?\s*(.*?)\s*\[([^]]+)\]\s*(\S+)$/\2 [\3, \1] \4/')"

    # move ticket number prefix into to new square brackets at end
    line="$(echo "${line}" | perl -pe 's/^([A-Z]+-[0-9]+):?\s*(.*?)\s*(\S+)$/\2 [\1] \3/')"

    # combine doubled square brackets at the end
    line="$(echo "${line}" | perl -pe 's/^\s*(.*?)\s*\[([A-Z]+-[0-9]+)\]\s*\[([^]]+)\]\s*(\S+)$/\1 [\3, \2] \4/')"

    changelog+=("- ${line}")
done <<< "${commits}"


# create or update comment
comment_body="$(cat <<EOF
## Changelog

\`\`\`markdown
$(IFS=$'\n'; echo "${changelog[*]}")
\`\`\`
EOF
)"

if [ -n "${existing_comment_id}" ]; then
    echo "Updating comment #${existing_comment_id}"
    gh api "/repos/${GITHUB_REPOSITORY}/issues/comments/${existing_comment_id}" -f body="${comment_body}"
else
    echo "Creating comment"
    gh pr comment "${pr_number}" --body "${comment_body}"
fi
