# Implementing New Deployment Patterns

Each new [deployment pattern](../concetps/deployments.md) will require several
component implementations in order to support the standard
[infrastructure as code workflow](../guides/github-workflow.md).

## Target Endpoint Pathing

The [target endpoint standard](../concepts/targets.md) mandates that target
endpoints exist under the `targets/{pattern}/{environ}` path, but allows for
pattern-defined nesting beneath that level. Each new pattern should document a
standard subpath structure to be used to contain target resources.

## Procedures

[Procedures](../concepts/procedures.md) are the heart of a deployment pattern
implementation. Procedures are the authoritative definition of how exactly a
pattern makes use of its available resources (deployments & targets), and should
be aware of the pathing conventions of target endpoints.

## GitHub Actions Workflows

Each pattern should include at least two GitHub workflows:

- `{pattern}-release.yml`: This workflow should wrap the
 ["release" procedure](../concepts/procedures.md), passing through any context
 which must be received from the GitHub platform.
- `{pattern}-report.yml`: For patterns which implement a
 ["desired" procedure](../concepts/procedures.md), this workflow should wrap
 it for the purpose of reporting the output to a PR comment.

## (Recommended) Sh/{pattern}-report.sh

For patterns which implement a ["desired" procedure](../concepts/procedures.md),
it may be helpful to implement a wrapper script which can accumulate and map
pending changes across all pattern targets. This can simplify the act of
reporting these changes to a number of subsequent channels, e.g., PR comments,
emails, slack messages, etc.
