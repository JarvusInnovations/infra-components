# = config =
#
# Provider of config querying methods
#
# == Methods ==
#
# `env_config`::
#   positionals:::
#     1. varname
#     2. git-config opts
#   returns:::
#     * corresponding value from engineEnv
#     * blank when <varname> does not exist
#
# `env_config_path`::
#   positionals:::
#     1. varname
#   returns:::
#     * <ENGINE_ENV_DIR>/<engineEnv-value>
#     * blank when <varname> does not exist
#
# `subject_config`::
#   positionals:::
#     1. varname
#     2. git-config opts
#   returns:::
#     * corresponding value from engineSubject
#     * blank when <varname> does not exist
#
# `subject_config_path`::
#   positionals:::
#     1. varname
#   returns:::
#     * <ENGINE_PROJECT_DIR>/<engineSubject-value>
#     * blank when <varname> does not exist
#
# `artifact_var`::
#   positionals:::
#     1. artifact name
#     2. varname
#     3. git-config opts
#   returns:::
#     * corresponding value from engineArtifact
#     * blank when <artifact-name> or <varname> does not exist
#
# `artifact_path`::
#   positionals:::
#     1. artifact name
#   returns:::
#     * <ENGINE_ARTIFACTS_DIR>/<engineArtifact-path-value>
#     * blank when <artifact-name> does not exist or does not define a "path" variable
#
# `artifacts_matching`::
#   positionals:::
#     1. artifact pattern. Anchors (^ and $) will break matching and must not be used.
#   returns:::
#     * Names of artifacts which match <artifact-pattern>
#
# `artifacts_using_producer`::
#   positionals:::
#     1. producer name
#   returns:::
#     * Names of artifacts which define "producer = <producer-name>"

GIT     ?= git

ifeq ($(GIT_DIR),)
GIT_DIR := $(shell $(GIT) rev-parse --git-path .)
endif

list_confs      = $(shell find '$(1)' -mindepth 1 -maxdepth 1 -name '*.conf' -exec basename {} \;)

PIPELINE_CONF_ARGS = $(foreach conf,$(call list_confs,$(shell realpath ../..)),-c 'include.path=$(shell realpath ../..)/$(conf)')
SUBJECT_CONF_ARGS  = $(foreach conf,$(call list_confs,$(shell realpath .)),-c 'include.path=$(shell realpath .)/$(conf)')
ENV_CONF_ARGS      = $(foreach conf,$(call list_confs,$(ENGINE_ENV_DIR)),-c 'include.path=$(ENGINE_ENV_DIR)/$(conf)')

ifneq ($(PIPELINE_CONF_ARGS),)
GIT += $(PIPELINE_CONF_ARGS)
endif

ifneq ($(SUBJECT_CONF_ARGS),)
GIT += $(SUBJECT_CONF_ARGS)
endif

ifneq ($(ENV_CONF_ARGS),)
GIT += $(ENV_CONF_ARGS)
endif

GIT_CONFIG := $(GIT) config

keys_matching            = $(shell $(GIT_CONFIG) --get-regexp '$(1)' $(if $(2),'$(2)') | awk '{print $$1}')
key_has_value            = $(shell $(GIT_CONFIG) $(1) | grep '^$(2)$$')
key_section_id           = $(shell echo '$(1)' | cut -d. -f2)

env_config               = $(shell $(GIT_CONFIG) $(2) engineEnv.$(ENGINE_ENV).$(1))
env_config_path          = $(if $(call env_config,$(1)),$(call env_pathjoin,$(call env_config,$(1))))

subject_config           = $(shell $(GIT_CONFIG) $(2) engineSubject.$(PIPELINE_NAME)/$(SUBJECT_NAME).$(1))
subject_config_path      = $(if $(call subject_config,$(1)),$(call project_pathjoin,$(call subject_config,$(1))))

artifact_var             = $(shell $(GIT_CONFIG) $(3) engineArtifact.$(1).$(2))
artifact_path            = $(if $(call artifact_var,$(1),path),$(call artifact_pathjoin,$(call artifact_var,$(1),path)))
artifacts_matching       = $(sort $(shell $(GIT_CONFIG) --get-regexp '^engineArtifact\.$(1)\..*$$' | cut -d. -f2))
# The complexity in this implementation "filters out" artifacts whose producers
# match, but have been overridden. I.e., if an artifact defines a matching
# producer value and also defines a non-matching, higher precedence value, it
# will not be a member of the returned list.
artifacts_using_producer = $(foreach key,$(call keys_matching,^engineArtifact\.[^.]+\.producer$$,^$(1)$$),$(if $(call key_has_value,$(key),$(1)),$(call key_section_id,$(key))))
