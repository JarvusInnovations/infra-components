#!/bin/bash


## build PR description body
echo
echo "Builing PR title+body content..."
diff_size=$(du -k '/tmp/kube.diff' | cut -f1)
pr_head_describe="$(git describe --always --tag)"

pr_title="Deploy ${BRANCH_RELEASE} ${pr_head_describe}"
pr_body="$(cat <<EOF
\`kubectl diff\` reports that applying ${pr_head_describe} will change:

\`\`\`diff
$(if (( diff_size > 50000)); then echo 'diff too big; review locally'; else cat /tmp/kube.diff; fi)
\`\`\`
EOF
)"


## generate initial commit for base if needed
if ! git ls-remote --exit-code --heads origin "${BRANCH_DEPLOY}"; then
    echo
    echo "Existing branch ${BRANCH_DEPLOY} not found, generating initial commit..."
    git fetch origin --unshallow
    _first_projected_commit=$(git rev-list --max-parents=0 --first-parent HEAD)
    git push origin "${_first_projected_commit}:refs/heads/${BRANCH_DEPLOY}"
fi


## check for existing PR
echo
echo "Looking for existing open PR for branch ${BRANCH_RELEASE}..."
_existing_pr_number=$(
    gh pr view "${BRANCH_RELEASE}" \
    --json number,state \
    --template '{{.number}}{{"\t"}}{{.state}}' \
    | grep OPEN \
    | awk '{print $1}'
)

if [ -n "${_existing_pr_number}" ]; then
    echo
    echo "Found existing PR #${_existing_pr_number}, updating description..."
    pr_url=$(
        gh api "/repos/${GITHUB_REPOSITORY}/pulls/${_existing_pr_number}" \
            --field title="${pr_title}" \
            --field body="${pr_body}" \
            --jq '.url'
    )
    echo "Updated PR: ${pr_url}"
else
    echo
    echo "Opening PR..."
    pr_url=$(
        gh pr create \
            --base "${BRANCH_DEPLOY}" \
            --head "${BRANCH_RELEASE}" \
            --title "${pr_title}" \
            --body "${pr_body}"
    )
    pr_number="${pr_url##*/}"
    echo "Opened PR #${pr_number}"
fi
