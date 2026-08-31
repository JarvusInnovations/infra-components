# GitHub Action: k8s-deploy

## Development

This action encapsulates most of its complexity in a standalone Bash scripts that accepts environment variables, making it easy to test locally with the help of a `.env` file you can point at a test repository.

1. Create `.env` from the template:

    ```bash
    cp .env.example .env
    ```

2. Paste a GitHub token and tailor repository/branches to your test target.

3. Save this directory's complete path in a shell variable:

    ```bash
    export GITHUB_ACTION_PATH="$(pwd)"
    ```

4. Change into your test target's local git clone:

    ```bash
    cd ~/Repositories/test-repo
    ```

5. Run target bash script with `.env` applied to emulate GitHub Actions context:

    - Add comment

        ```bash
        eval $(< "${GITHUB_ACTION_PATH}/.env") "${GITHUB_ACTION_PATH}/add-comment.sh"
        ```
