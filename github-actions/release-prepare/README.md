# GitHub Action: release-prepare

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
