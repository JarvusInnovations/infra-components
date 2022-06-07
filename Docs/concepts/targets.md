# targets

A target is a directory which contains all of the instance-specific resources
required to deploy an instance of an infrastructure composition (e.g.,
environment-specific variables). The path convention for targets can vary
slightly depending on the pattern, but all target paths will start with
`targets/{pattern}/{environ}`, where `{pattern}` is the name of a
deployment pattern which the target is matched to (e.g., `terraform`,
`kubernetes`, etc.) and `{environ}` is the name of an infrastructure environment
(e.g., `prod`, `stg`, etc). The path to a target directory may be more
generically referred to as a target endpoint.

## terraform

Terraform target endpoints are pathed using the convention
`targets/terraform/{environ}/{deployment}`, where `{deployment}` is the name of
a deployment within `deployments/terraform`. This endpoint pathing convention
has the effect that multiple targets can be associated with an environment
and each deployment endpoint can be utilized by multiple targets, but each
target endpoint must be associated with exactly one deployment.
