# = terraform =
#
# The Infrastructure as Code tool by Hashicorp
#
# == Inputs ==
#
# |==================================================
# | Section       | Name                | Description
# | engineSubject | tfRootModulePath    | Project subpath to Terraform project
# | engineSubject | tfVarFilePath [...] | Project subpath to a subject-local variable file
# | engineSubject | tfBackendPath       | Project subpath to a subject-local backend config. This is used by any implicit `terraform init` commands.
# | engineEnv     | tfVarFilePath [...] | Env subpath to a pipeline-global var file. Extends `engineSubject.tfVarFilePath`.
# | engineEnv     | tfBackendPath       | Env subpath to a pipeline-global backend config. Overrides `engineSubject.tfBackendPath`.
# |================================================
#
# == Steps ==
#
# `terraform-plan`::
#   description:::
#     Runs a `terraform plan` on the specified project
#   inputs:::
#     * engineSubject.tfRootModulePath
#     * engineSubject.tfVarFilePath
#     * engineEnv.tfVarFilePath
#
# `terraform-apply`::
#   description:::
#     Runs a `terraform apply` on the specified project
#   inputs:::
#     * engineSubject.tfRootModulePath
#     * engineSubject.tfVarFilePath
#     * engineEnv.tfVarFilePath
#
# `terraform-validate`::
#   description:::
#     Runs a `terraform validate` on the specified project
#   inputs:::
#     * engineSubject.tfRootModulePath
#
# == Methods ==
#
# `tf_plan_status`::
#   inputs:::
#     * engineSubject.tfRootModulePath
#     * engineSubject.tfVarFilePath
#     * engineEnv.tfVarFilePath
#   return:::
#     * Detailed exit code of `terraform plan`

TERRAFORM                   ?= terraform
TERRAFORM_ROOT_MODULE       ?= $(call subject_config_path,tfRootModulePath)
TERRAFORM_SUBJECT_VAR_FILES ?= $(call subject_config,tfVarFilePath,--get-all)
TERRAFORM_ENV_VAR_FILES     ?= $(call env_config,tfVarFilePath,--get-all)
TERRAFORM_SUBJECT_BACKEND   ?= $(call subject_config_path,tfBackendPath)
TERRAFORM_ENV_BACKEND       ?= $(call env_config_path,tfBackendPath)

ifneq ($(TERRAFORM_SUBJECT_BACKEND),)
TERRAFORM_BACKEND_CONFIG    := $(TERRAFORM_SUBJECT_BACKEND)
endif

ifneq ($(TERRAFORM_ENV_BACKEND),)
TERRAFORM_BACKEND_CONFIG    := $(TERRAFORM_ENV_BACKEND)
endif

ifneq ($(TERRAFORM_ROOT_MODULE),)
TERRAFORM += '-chdir=$(TERRAFORM_ROOT_MODULE)'
endif

ifneq ($(TERRAFORM_SUBJECT_VAR_FILES),)
TERRAFORM_VAR_FILES += $(patsubst %,'-var-file=$(ENGINE_PROJECT_DIR)/%',$(TERRAFORM_SUBJECT_VAR_FILES))
endif

ifneq ($(TERRAFORM_ENV_VAR_FILES),)
TERRAFORM_VAR_FILES += $(patsubst %,'-var-file=$(ENGINE_LOCAL_DIR)/%',$(TERRAFORM_ENV_VAR_FILES))
endif

TERRAFORM_DOTDIR := $(if $(TERRAFORM_ROOT_MODULE),$(shell realpath --relative-to=. '$(TERRAFORM_ROOT_MODULE)')/.terraform,.terraform)

tf_plan_status    = $(shell $(TERRAFORM) plan -detailed-exitcode $(TERRAFORM_VAR_FILES) &>/dev/null; echo $$?)

$(TERRAFORM_DOTDIR):
	$(TERRAFORM) init $(if $(TERRAFORM_BACKEND_CONFIG),'-backend-config=$(TERRAFORM_BACKEND_CONFIG)')

terraform-plan: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) plan -compact-warnings $(TERRAFORM_VAR_FILES)

terraform-apply: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) apply -auto-approve $(TERRAFORM_VAR_FILES)

terraform-validate: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) validate

terraform-clean:
	rm -vrf $(TERRAFORM_DOTDIR)

.PHONY: terraform-plan
.PHONY: terraform-apply
.PHONY: terraform-validate
.PHONY: terraform-clean
