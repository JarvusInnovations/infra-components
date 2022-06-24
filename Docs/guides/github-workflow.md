# GitHub Workflow

All changes to live infrastructure should flow through GitHub for peer review
and auditability. The workflow to do this is the same across all environments,
with the only difference being the designation of which branch releases changes
into which environment.

## Branch designations

- `main`: All changes merged into this branch will release into the `prod`
 enivronment.
- `releases/{environ}`: All changes pushed or merged to a branch which follows
 this naming convention will release changes into the environment `{environ}`.

## Test changes (non-prod environments)

In order to test changes, push them to a `releases/{environ}` branch.

## Deploy changes (prod)

1. Open a PR from the topic branch into `main`
2. Verify that the reported changes meet expectations
3. Receive peer review & aproval
4. Merge PR
5. Validate results via job output & checking backend resources
