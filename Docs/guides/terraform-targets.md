# Terraform Target Resources

Within the [terraform target endpoint](../concepts/targets.md), there are a
number of specially designated resource names which will be recognized by the
terraform [procedures](../concepts/procedures.md).

## target.tfbacknd

This is a backend configuration file which will be passed to `terraform init`.
It should provide configuration for the state backend which represents the
target.

## target.tfvars

This is a terraform var file which will be passed to invocations of
`terraform plan` and `terraform apply`.
