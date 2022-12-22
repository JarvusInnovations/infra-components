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
# `artifact_match`::
#   positionals:::
#     1. artifact pattern. Anchors (^ and $) will break matching and must not be used.
#   returns:::
#     * All artifact names which match <artifact-pattern> and define a "path" variable
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

env_config               = $(shell $(GIT_CONFIG) $(2) engineEnv.$(ENGINE_ENV).$(1))
env_config_path          = $(if $(call env_config,$(1)),$(call env_pathjoin,$(call env_config,$(1))))

subject_config           = $(shell $(GIT_CONFIG) $(2) engineSubject.$(PIPELINE_NAME)/$(SUBJECT_NAME).$(1))
subject_config_path      = $(if $(call subject_config,$(1)),$(call project_pathjoin,$(call subject_config,$(1))))

artifact_var             = $(shell $(GIT_CONFIG) $(3) engineArtifact.$(1).$(2))
artifact_path            = $(if $(call artifact_var,$(1),path),$(call artifact_pathjoin,$(call artifact_var,$(1),path)))
artifact_match           = $(shell $(GIT_CONFIG) --get-regexp '^engineArtifact\.$(1)\.path$$' | cut -d. -f2)
artifacts_using_producer = $(shell $(GIT_CONFIG) --get-regexp '^engineArtifact\.[^.]+\.producer$$' '^$(1)$$' | cut -d. -f2)
