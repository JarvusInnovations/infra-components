# deployments

A deployment is a directory which contains all of the genericized resources
required to deploy an instance of an infrastructure composition. All resources
for a specific deployment are stored under the path
`deployments/{pattern}/{name}`, where `{pattern}` is the name of a specific
deployment method (e.g., `terraform`, `kubernetes`, etc.) and `{name}` is a name
for the infrastructure composition (e.g., `data-infra`, `user-workstations`,
etc.). The path to a deployment directory may be more generically referred to as
a deployment endpoint.
