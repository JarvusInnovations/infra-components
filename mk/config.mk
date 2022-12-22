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

# call signature : $(call artifact_var,<artifact-name>,<varname>,<git-config-opts>)
# expands to     : git config <git-config-opts> artifact.<artifact-name>.<varname>
# returns        : <varname-value>
artifact_var        = $(shell $(GIT_CONFIG) $(3) engineArtifact.$(1).$(2))

# call signature : $(call env_config_path,<varname>)
# returns        : <engine-env-dir>/<varname-value>
env_config_path     = $(if $(call env_config,$(1)),$(call env_pathjoin,$(call env_config,$(1))))

# call signature : $(call artifact_path,<artifact-name>)
# returns        : <engine-artifacts-dir>/<artifact-path-var>
artifact_path       = $(if $(call artifact_var,$(1),path),$(call artifact_pathjoin,$(call artifact_var,$(1),path)))

# call signature : $(call subject_config_path,<varname>)
# returns        : <engine-project-dir>/<varname-value>
subject_config_path = $(if $(call subject_config,$(1)),$(call project_pathjoin,$(call subject_config,$(1))))

# call signature : $(call artifact_match,<name-pattern>)
# returns        : <matched-artifact-name> ...
artifact_match      = $(shell $(GIT_CONFIG) --get-regexp '^engineArtifact\.$(1)\.path$$' | cut -d. -f2)
