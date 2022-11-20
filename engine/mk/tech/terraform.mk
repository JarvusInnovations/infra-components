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
TERRAFORM_ROOT_MODULE       ?= $(call config,subject,tfRootModule)
TERRAFORM_SUBJECT_VAR_FILES ?= $(call config,subject,tfVarFile,--get-all)
TERRAFORM_ENV_VAR_FILES     ?= $(call config,env,tfVarFile,--get-all)
TERRAFORM_SUBJECT_BACKEND   ?= $(call config,subject,tfBackend)
TERRAFORM_ENV_BACKEND       ?= $(call config,env,tfBackend)

ifneq ($(TERRAFORM_SUBJECT_BACKEND),)
TERRAFORM_BACKEND_CONFIG    := $(SUBJECT_DIR)/$(TERRAFORM_SUBJECT_BACKEND)
endif

ifneq ($(TERRAFORM_ENV_BACKEND),)
TERRAFORM_BACKEND_CONFIG    := $(ENGINE_ENV_DIR)/$(TERRAFORM_ENV_BACKEND)
endif

ifneq ($(TERRAFORM_ROOT_MODULE),)
TERRAFORM += '-chdir=$(SUBJECT_DIR)/$(TERRAFORM_ROOT_MODULE)'
endif

ifneq ($(TERRAFORM_SUBJECT_VAR_FILES),)
TERRAFORM_VAR_FILES += $(patsubst %,'-var-file=$(SUBJECT_DIR)/%',$(TERRAFORM_SUBJECT_VAR_FILES))
endif

ifneq ($(TERRAFORM_ENV_VAR_FILES),)
TERRAFORM_VAR_FILES += $(patsubst %,'-var-file=$(ENGINE_ENV_DIR)/%',$(TERRAFORM_ENV_VAR_FILES))
endif

TERRAFORM_DOTDIR := $(if $(TERRAFORM_ROOT_MODULE),$(TERRAFORM_ROOT_MODULE)/.terraform,.terraform)

$(TERRAFORM_DOTDIR):
	$(TERRAFORM) init $(if $(TERRAFORM_BACKEND_CONFIG),'-backend-config=$(TERRAFORM_BACKEND_CONFIG)')

terraform-plan: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) plan -compact-warnings $(TERRAFORM_VAR_FILES)

terraform-apply: $(TERRAFORM_DOTDIR)
	$(TERRAFORM) apply -auto-approve $(TERRAFORM_VAR_FILES)

.PHONY: terraform-plan
.PHONY: terraform-apply
