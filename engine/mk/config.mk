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
# `env_config_artifact`::
#   positionals:::
#     1. varname
#   returns:::
#     * <ENGINE_ARTIFACTS_DIR>/<engineEnv-value>
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
# `subject_config_artifact`::
#   positionals:::
#     1. varname
#   returns:::
#     * <ENGINE_ARTIFACTS_DIR>/<engineSubject-value>
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
# `artifacts_filter_equalto`::
#   positionals:::
#     1. set of artifact names
#     2. varname to check on each artifact
#     3. value for equality test
#   returns:::
#     * Names of artifacts which define "<varname> = <value>"
#
# `artifacts_filter_has`::
#   positionals:::
#     1. set of artifact names
#     2. varname to check on each artifact
#     3. [optional] value for equality test
#   returns:::
#     * Names of artifacts which define <varname> at least once
#     * Names of artifacts which define "<varname> = <value>" at least once
#
# `artifacts_lookupby_relpath`::
#   positionals:::
#     1. set of artifact IDs
#     2. a relative path formed by `artifact_relpathjoin`
#   returns:::
#     * Artifact IDs whose "path" value matches `artifact_relpathstrip $(2)`
#
# `artifacts_lookupby_abspath`::
#   positionals:::
#     1. set of artifact IDs
#     2. an absolute path formed by `artifact_pathjoin`
#   returns:::
#     * Artifact IDs whose "path" value matches `artifact_pathstrip $(2)`

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

env_config                 = $(shell $(GIT_CONFIG) $(2) engineEnv.$(ENGINE_ENV).$(1))
env_config_path            = $(if $(call env_config,$(1)),$(call env_pathjoin,$(call env_config,$(1))))
env_config_artifact        = $(call artifact_path,$(call env_config,$(1)))

subject_config             = $(shell $(GIT_CONFIG) $(2) engineSubject.$(PIPELINE_NAME)/$(SUBJECT_NAME).$(1))
subject_config_path        = $(if $(call subject_config,$(1)),$(call project_pathjoin,$(call subject_config,$(1))))
subject_config_artifact    = $(call artifact_path,$(call subject_config,$(1)))

artifact_var               = $(shell $(GIT_CONFIG) $(3) engineArtifact.$(1).$(2))
artifact_path              = $(if $(call artifact_var,$(1),path),$(call artifact_pathjoin,$(call artifact_var,$(1),path)))
artifacts_matching         = $(sort $(shell $(GIT_CONFIG) --get-regexp '^engineArtifact\.$(1)\.[^.]+$$' | cut -d. -f2))
artifacts_filter_equalto   = $(foreach id,$(1),$(if $(filter $(3),$(call artifact_var,$(id),$(2))),$(id)))
artifacts_filter_has       = $(foreach id,$(1),$(if $(call artifact_var,$(id),$(2) $(if $(3),'^$(3)$$'),--get),$(id)))
artifacts_lookupby_relpath = $(call artifacts_filter_equalto,$(1),path,$(call artifact_relpathstrip,$(2)))
artifacts_lookupby_abspath = $(call artifacts_filter_equalto,$(1),path,$(call artifact_pathstrip,$(2)))
