# procedures

A procedure is a script with a standardized interface which implements a
specific operation for a particular [deployment pattern](). The two standard
operations which each pattern can implement via procedures are "converge" and
"desired". Procedures follow the conventional name
`procedures/{pattern}-{operation}.sh`. Procedures accept a standard set of
inputs and produce a standard set of outputs and/or results.

## inputs

Procedure inputs are accepted as environment variables. Arguments are ignored.

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
procedure. This procedure must implement an exit code interface which
indicates whether or not achieving desired state would require the application
of changes.

- `0`: The target is in the desired state
- `1`: The target must be changed in order to enter the desired state
- >= `2`: An error ocurred in the execution of the procedure

## Operation: converge

This procedure applies changes to the target which are required for it to enter
the desired state. If changes are applied, it should output a human-readable
indication that changes were applied with some summary of the applied changes.
Any non-zero exit code will be regarded as a failure to apply one or more
changes.
