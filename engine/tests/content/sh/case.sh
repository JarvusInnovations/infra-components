set -e

test_cmd()
{
  echo + "$@" >&2
  eval "$@"
}

test_die()
{
  echo fatal: "$@" >&2
  exit 1
}
