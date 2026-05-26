#!/bin/bash

## build comment body
echo
echo "Builing coment body content..."
comment_body="$(cat <<EOF
\`kubectl apply\` output (excluding unchanged) for $(git describe --always --tag) was:

\`\`\`
$(cat /tmp/kube.log | grep -v ' unchanged$')
\`\`\`
EOF
)"


## get most recent merged PR
echo
echo "Looking for most recent merged PR for branch ${BRANCH_RELEASE}..."
pr_number=$(
    gh pr list \
        --head "${BRANCH_RELEASE}" \
        --base "${BRANCH_DEPLOY}" \
        --state merged \
        --limit 1 \
        --json number \
        --jq '.[0].number'
)


## post comment
if [ -n "${pr_number}" ]; then
    echo
    echo "Adding comment to PR #${pr_number}..."
    gh pr comment "${pr_number}" \
        --body "${comment_body}"
fi
