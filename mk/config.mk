GIT     ?= git

ifeq ($(GIT_DIR),)
GIT_DIR := $(shell $(GIT) rev-parse --git-path .)
endif

PIPELINE_CONFS := $(wildcard $(shell realpath ../..)/*.conf)
SUBJECT_CONFS  := $(wildcard $(shell realpath .)/*.conf)
ENV_CONFS      := $(wildcard $(shell realpath '$(ENGINE_ENV_DIR)')/*.conf)

# FIXME: this use of patsubst may break the module when abspaths have whitespace
ifneq ($(PIPELINE_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(PIPELINE_CONFS))
endif

ifneq ($(SUBJECT_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(SUBJECT_CONFS))
endif

ifneq ($(ENV_CONFS),)
GIT += $(patsubst %, -c 'include.path=%',$(ENV_CONFS))
endif

GIT_CONFIG := $(GIT) config

# call signature : $(call subject_config,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> subject.<pipeline-name/subject-name>.<varname> [git-config-value-pattern]
# returns        : <varname-value>
subject_config  = $(shell $(GIT_CONFIG) $(2) engineSubject.$(PIPELINE_NAME)/$(SUBJECT_NAME).$(1))

# call signature : $(call env_config,<varname> [git-config-value-pattern],<git-config-opts>)
# expands to     : git config <git-config-opts> env.<engine-env>.<varname> [git-config-value-pattern]
# returns        : <varname-value>
env_config      = $(shell $(GIT_CONFIG) $(2) engineEnv.$(ENGINE_ENV).$(1))

# call signature : $(call env_config_path,<varname>)
# returns        : <engine-env-dir>/<varname-value>
env_config_path     = $(if $(call env_config,$(1)),$(call env_pathjoin,$(call env_config,$(1))))

# call signature : $(call subject_config_path,<varname>)
# returns        : <engine-home>/<varname-value>
subject_config_path = $(if $(call subject_config,$(1)),$(call home_pathjoin,$(call subject_config,$(1))))
