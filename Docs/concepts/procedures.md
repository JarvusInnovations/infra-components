# procedures

A procedure is a scripted interface which implements a specific operation for a
particular [deployment pattern](./deployments.md). Procedures follow the
conventional name `procedures/{pattern}-{operation}.sh`. Procedures accept a
documented set of inputs (which may vary by pattern and/or operation) and
produce a standard set of outputs and/or results.

## Available Inputs

Procedure inputs are accepted as environment variables. Arguments are processed
on a per-implementation basis.

- `INFRA_DEPLOYMENT_NAME`: The name of the deployment which the procedure shall
 perform. This must correspond to a directory name in `deployments/{pattern}`,
 where `{pattern}` is the name of the pattern which the procedure operates for.
- `INFRA_TARGET_NAME`: The name of the target which the procedure shall deploy
 to. This must correspond to a directory name in `targets/{pattern}`, where
 `{pattern}` is the name of the pattern which the procedure operates for.

## Operation: desired

This procedure should output a human-readable representation of the desired
target state. It should typically be some sort of differential state which
shows the changes that would be applied by the execution of the "converge"
procedure.

### accepts

- `INFRA_DEPLOYMENT_NAME`
- `INFRA_TARGET_NAME`

### exit codes

- `0`: The target is in the desired state
- `1`: The target must be changed in order to enter the desired state
- >= `2`: An error ocurred in the execution of the procedure

## Operation: converge

This procedure applies changes to the target which are required for it to enter
the desired state. If changes are applied, it should output a human-readable
indication that changes were applied with some summary of the applied changes.

### accepts

- `INFRA_DEPLOYMENT_NAME`
- `INFRA_TARGET_NAME`

### exit codes

- `0`: All changes were applies successfully
- >= `1`: One or more changes failed to apply

## Operation: release

A release procedure is a free-form one which orchestrates a converge operation
for a particular pattern. What it means to "orchestrate" a converge will vary by
pattern, but an example of a simple release operation might be to run a
"desired" operation followed by a "converge" operation if the "desired"
operation reports pending changes.

### accepts

Implementation defined

### exit codes

- `0`: Release operation was successful
- >= `1`: The release operation halted on a failure
