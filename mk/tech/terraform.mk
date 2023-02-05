# = terraform =
#
# The Infrastructure as Code tool by Hashicorp
#
# == Options ==
#
# |======================================================
# | Name                | Reference Type    | Description
# | tfRootModule        | var               | Terraform root module source
# | tfBackendConfig     | var               | A terraform backend-config source. This is used by any implicit `terraform init` commands.
# | tfVarFileItem       | list              | A sequence of var-file sources
# |======================================================
#
# == Artifacts ==
#
# |============================================================
# | Option              | Value                   | Description
# | producer            | terraform-plan          | Artifacts with this value will be used by terraform-plan-artifacts-produce
# |============================================================
#
# == Steps ==
#
# `terraform-plan`::
#   description:::
#     Runs a `terraform plan` on the specified project
#   inputs:::
#     * tfRootModule
#     * tfVarFileItem
#
# `terraform-apply`::
#   description:::
#     Runs a `terraform apply` on the specified project
#   inputs:::
#     * tfRootModule
#     * tfVarFileItem
#
# `terraform-validate`::
#   description:::
#     Runs a `terraform validate` on the specified project
#   inputs:::
#     * tfRootModule
#
# `terraform-plan-artifacts-produce`::
#   description:::
#     Writes terraform plan output to `<artifact>.path`
#   artifacts:::
#     * producer=terraform-plan
#   inputs:::
#     * <artifact>.path
#
# `terraform-plan-artifacts-clean`::
#   description:::
#     Deletes all produced artifacts
#   artifacts:::
#     * producer=terraform-plan
#   inputs:::
#     * <artifact>.path
#
# == Methods ==
#
# `tf_plan_status`::
#   inputs:::
#     * tfRootModule
#     * tfVarFileItem
#   return:::
#     * Detailed exit code of `terraform plan`

ifeq ($(TERRAFORM),)
TERRAFORM                     := terraform
endif

ifeq ($(TERRAFORM_ROOT_MODULE),)
TERRAFORM_ROOT_MODULE         := $(call opt_pipeline_var,tfRootModule)
endif

ifeq ($(TERRAFORM_VAR_FILES),)
TERRAFORM_VAR_FILES           := $(call opt_pipeline_list,tfVarFileItem)
endif

ifeq ($(TERRAFORM_BACKEND_CONFIG),)
TERRAFORM_BACKEND_CONFIG      := $(call opt_pipeline_var,tfBackendConfig)
endif

ifeq ($(TERRAFORM_PLAN_ARTIFACTS),)
TERRAFORM_PLAN_ARTIFACTS      := $(call filter_artifacts_opt_eq_val,$(call artifacts_matching,.+),producer,terraform-plan)
endif

ifneq ($(TERRAFORM_ROOT_MODULE),)
TERRAFORM                     += '-chdir=$(TERRAFORM_ROOT_MODULE)'
endif

ifneq ($(TERRAFORM_VAR_FILES),)
TERRAFORM_VAR_FILE_ARGS       := $(foreach varfile,$(TERRAFORM_VAR_FILES),-var-file '$(varfile)')
endif

ifneq ($(TERRAFORM_PLAN_ARTIFACTS),)
TERRAFORM_PLAN_ARTIFACT_PATHS := $(foreach id,$(TERRAFORM_PLAN_ARTIFACTS),$(call artifact_path,$(id)))
endif

ifneq ($(KUBECONFIG),)
KUBE_CONFIG_PATH := $(KUBECONFIG)
export KUBE_CONFIG_PATH
endif

TERRAFORM_DOTDIR := $(if $(TERRAFORM_ROOT_MODULE),$(call path_relto,$(TERRAFORM_ROOT_MODULE),.)/.terraform,.terraform)

tf_plan_status    = $(shell $(TERRAFORM) plan -detailed-exitcode $(TERRAFORM_VAR_FILE_ARGS) >/dev/null 2>&1; echo $$?)

$(TERRAFORM_DOTDIR):
	$(TERRAFORM) init $(if $(TERRAFORM_BACKEND_CONFIG),'-backend-config=$(TERRAFORM_BACKEND_CONFIG)')

terraform-plan: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) plan -compact-warnings $(TERRAFORM_VAR_FILE_ARGS)

terraform-apply: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) apply -auto-approve $(TERRAFORM_VAR_FILE_ARGS)

terraform-validate: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) validate

terraform-clean:
	rm -vrf $(TERRAFORM_DOTDIR)

terraform-plan-artifacts-produce: $(TERRAFORM_PLAN_ARTIFACT_PATHS)
$(TERRAFORM_PLAN_ARTIFACT_PATHS):
	$(TERRAFORM) plan -compact-warnings -no-color $(TERRAFORM_VAR_FILE_ARGS) > '$@'

terraform-plan-artifacts-clean:
	rm -vf $(TERRAFORM_PLAN_ARTIFACT_PATHS)

.PHONY: terraform-plan
.PHONY: terraform-apply
.PHONY: terraform-validate
.PHONY: terraform-clean
.PHONY: terraform-plan-artifacts-produce
.PHONY: terraform-plan-artifacts-clean
.PHONY: $(TERRAFORM_PLAN_ARTIFACT_PATHS)
