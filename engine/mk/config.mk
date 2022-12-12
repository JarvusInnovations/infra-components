GIT     ?= git

ifeq ($(GIT_DIR),)
GIT_DIR := $(shell $(GIT) rev-parse --git-path .)
endif

PIPELINE_CONFS := $(wildcard $(PIPELINE_DIR)/*.conf)
SUBJECT_CONFS  := $(wildcard *.conf)
ENV_CONFS      := $(wildcard $(ENGINE_ENV_DIR)/*.conf)

ifneq ($(PIPELINE_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(PIPELINE_CONFS))
endif

ifneq ($(SUBJECT_CONFS),)
GIT += $(patsubst %, -c 'include.path=$(shell realpath .)/%',$(SUBJECT_CONFS))
endif

ifneq ($(ENV_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(ENV_CONFS))
endif

GIT_CONFIG := $(GIT) config

# call signature : $(call subject_config,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> subject.<pipeline-name/subject-name>.<varname> [git-config-value-pattern]
# returns        : <varname-value>
subject_config  = $(shell $(GIT_CONFIG) $(2) subject.$(PIPELINE_NAME)/$(SUBJECT_NAME).$(1))

# call signature : $(call env_config,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> env.<engine-env>.<varname> [git-config-value-pattern]
# returns        : <varname-value>
env_config      = $(shell $(GIT_CONFIG) $(2) env.$(ENGINE_ENV).$(1))

env_config_path = $(if $(call env_config,$(1)),$(call env_pathjoin,$(call env_config,$(1))))