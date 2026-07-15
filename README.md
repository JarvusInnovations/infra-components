# GitHub Action: release-prepare

Opens/refreshes the `Release: vX.Y.Z` pull request from the working branch into the release branch, computing the next version as **last release tag + patch bump** and posting a changelog comment.

## Inputs

| Input | Required | Default | Description |
| --- | --- | --- | --- |
| `github-token` | yes | — | Token used to open/update the PR and read commit/PR metadata. |
| `release-branch` | no | `main` | Branch releases merge into (the base of the Release PR). |
| `release-tag-match` | no | `''` (all tags) | Glob passed to `git describe --match`, restricting which tags are considered when computing the next version. |

### `release-tag-match` — isolating one tag track

The next version is derived from the most recent tag reachable on the release branch. When a repo publishes **multiple artifacts on separate prefix-namespaced tag tracks that share one git tag space** — e.g. a JS package on `v*` alongside native-binding tracks like `holo-tree-v*` / `foo-v*` — a tag from *another* track can be the topologically nearest one and poison the computed title (bumping `holo-tree-v0.5.0` → `holo-tree-v0.5.1` for what should be a `v*` release). Set `release-tag-match` to this release's own track so only its tags count:

```yaml
- uses: JarvusInnovations/infra-components@channels/github-actions/release-prepare/latest
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    release-branch: master
    release-tag-match: 'v[0-9]*'   # the JS `v*` track, not the `*-v*` binding tracks
```

A no-match (a brand-new track) falls through to the `v0.1.0` default. Omit the input to consider all tags (prior behavior, unchanged).

## Development

This action encapsulates most of its complexity in a standalone Bash script that accepts environment variables, making it easy to test locally with the help of a `.env` file you can point at a test repository.

1. Create `.env` from the template:

    ```bash
    cp .env.example .env
    ```

2. Paste a GitHub token and tailor repository/branches to your test target.

3. Run bash script with `.env` applied to emulate GitHub Actions context:

    ```bash
    eval $(< .env) ./pull-request.sh
    ```
