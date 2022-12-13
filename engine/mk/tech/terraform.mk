#
# Config:
#
# [subject "<name>"]
# tfRootModule = <subject-subpath>
# tfVarFile    = <subject-subpath>
# tfBackend    = <subject-subpath>
# [env     "<name>"]
# tfVarFile    = <env-subpath>
# tfBackend    = <env-subpath>
#

TERRAFORM                   ?= terraform
TERRAFORM_ROOT_MODULE       ?= $(call subject_config,tfRootModule)
TERRAFORM_SUBJECT_VAR_FILES ?= $(call subject_config,tfVarFile,--get-all)
TERRAFORM_ENV_VAR_FILES     ?= $(call env_config,tfVarFile,--get-all)
TERRAFORM_SUBJECT_BACKEND   ?= $(call subject_config,tfBackend)
TERRAFORM_ENV_BACKEND       ?= $(call env_config,tfBackend)

ifneq ($(TERRAFORM_SUBJECT_BACKEND),)
TERRAFORM_BACKEND_CONFIG    := $(ENGINE_HOME)/$(TERRAFORM_SUBJECT_BACKEND)
endif

ifneq ($(TERRAFORM_ENV_BACKEND),)
TERRAFORM_BACKEND_CONFIG    := $(ENGINE_ENV_DIR)/$(TERRAFORM_ENV_BACKEND)
endif

ifneq ($(TERRAFORM_ROOT_MODULE),)
TERRAFORM += '-chdir=$(ENGINE_HOME)/$(TERRAFORM_ROOT_MODULE)'
endif

ifneq ($(TERRAFORM_SUBJECT_VAR_FILES),)
TERRAFORM_VAR_FILES += $(patsubst %,'-var-file=$(ENGINE_HOME)/%',$(TERRAFORM_SUBJECT_VAR_FILES))
endif

ifneq ($(TERRAFORM_ENV_VAR_FILES),)
TERRAFORM_VAR_FILES += $(patsubst %,'-var-file=$(ENGINE_ENV_DIR)/%',$(TERRAFORM_ENV_VAR_FILES))
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
