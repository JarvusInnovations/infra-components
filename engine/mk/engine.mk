# = engine =
#
# Provider of global context and path resolution methods
#
# == Context ==
#
# |===================================
# | Name                 | Description
# | MK                   | Relative path to the engine module (mk) directory. This is the only value which is not exported (since it is a relative path).
# | ENGINE_SYSTEM_DIR    | Absolute path to engine runtime directory
# | ENGINE_PROJECT_DIR   | Absolute path to engine consumer project
# | ENGINE_ENV           | Name of engineEnv to be used when querying engine configs
# | ENGINE_LOCAL_DIR     | Absolute path to directory which engineEnv paths are relative to and from which highest precedence .conf files are collected
# | ENGINE_ARTIFACTS_DIR | Absolute path to directory which engineArtifact paths are relative to
# | ENGINE_PIPELINES_DIR | Absolute path to directory which contains project pipelines
# |===================================
#
# == Methods ==
#
# `path_relto`::
#   positionals:::
#     1. dest path
#     2. start dir
#   returns:::
#     * A relative path from <start-dir> to <dest-path> on the current system
#
# `env_pathjoin`::
#   positionals:::
#     1. subpath
#   returns:::
#     * <ENGINE_LOCAL_DIR>/<subpath>
#
# `env_pathstrip`::
#   positionals:::
#     1. abspath
#   returns:::
#     * A subpath with ENGINE_LOCAL_DIR stripped from the beginning
#     * <abspath> if it does not start with ENGINE_LOCAL_DIR
#
# `project_pathjoin`::
#   positionals:::
#     1. subpath
#   returns:::
#     * <ENGINE_PROJECT_DIR>/<subpath>
#
# `project_pathstrip`::
#   positionals:::
#     1. abspath
#   returns:::
#     * A subpath with ENGINE_PROJECT_DIR stripped from the beginning
#     * <abspath> if it does not start with ENGINE_PROJECT_DIR
#
# `artifact_pathjoin`::
#   positionals:::
#     1. subpath
#   returns:::
#     * <ENGINE_ARTIFACTS_DIR>/<subpath>
#
# `artifact_pathstrip`::
#   positionals:::
#     1. abspath
#   returns:::
#     * A subpath with ENGINE_ARTIFACTS_DIR stripped from the beginning
#     * <abspath> if it does not start with ENGINE_ARTIFACTS_DIR
#
# `artifact_relpathjoin`::
#   positionals:::
#     1. subpath
#   returns:::
#     * {relative path to ENGINE_ARTIFACTS_DIR}/<subpath>
#
# `artifact_relpathstrip`::
#   positionals:::
#     1. relpath
#   returns:::
#     * A subpath with the relative path to ENGINE_ARTIFACTS_DIR stripped from the beginning
#     * <relpath> if it does not start with a relative path to ENGINE_ARTIFACTS_DIR

-include local.mk

ifeq ($(MK),)
MK                   := $(shell dirname '$(lastword $(MAKEFILE_LIST))')
endif

-include $(MK)/../../.engine-project.mk

ifeq ($(LIB),)
LIB                  := $(MK)/../lib
endif

path_relto            = $(shell $(LIB)/sh/path-relto.sh '$(1)' '$(2)')

ifeq ($(ENGINE_SYSTEM_DIR),)
ENGINE_SYSTEM_DIR    := $(shell realpath '$(MK)/..')
endif

ifeq ($(ENGINE_PROJECT_DIR),)
ENGINE_PROJECT_DIR   := $(shell realpath '$(MK)/../..')
endif

ifeq ($(ENGINE_ENV),)
ENGINE_ENV           := dev
endif

# These abspaths are resolved using path_relto because realpath will fail if
# multiple path components do not exist

ifeq ($(ENGINE_LOCAL_DIR),)
ENGINE_LOCAL_DIR     := $(shell echo $(call path_relto,$(shell git rev-parse --git-path engine/local),/) | sed 's,^\.,,')
endif

ifeq ($(ENGINE_ARTIFACTS_DIR),)
ENGINE_ARTIFACTS_DIR := $(shell echo $(call path_relto,$(shell git rev-parse --git-path engine/artifacts),/) | sed 's,^\.,,')
endif

ifeq ($(ENGINE_PIPELINES_DIR),)
ENGINE_PIPELINES_DIR := $(ENGINE_PROJECT_DIR)/pipelines
endif

env_pathjoin       = $(ENGINE_LOCAL_DIR)/$(1)
env_pathstrip      = $(patsubst $(ENGINE_LOCAL_DIR)/%,%,$(1))

project_pathjoin   = $(ENGINE_PROJECT_DIR)/$(1)
project_pathstrip  = $(patsubst $(ENGINE_PROJECT_DIR)/%,%,$(1))

artifact_pathjoin  = $(ENGINE_ARTIFACTS_DIR)/$(1)
artifact_pathstrip = $(patsubst $(ENGINE_ARTIFACTS_DIR)/%,%,$(1))

artifact_relpathjoin  = $(call path_relto,$(ENGINE_ARTIFACTS_DIR),.)/$(1)
artifact_relpathstrip = $(patsubst $(call path_relto,$(ENGINE_ARTIFACTS_DIR),.)/%,%,$(1))

export ENGINE_SYSTEM_DIR
export ENGINE_PROJECT_DIR
export ENGINE_ENV
export ENGINE_LOCAL_DIR
export ENGINE_ARTIFACTS_DIR
export ENGINE_PIPELINES_DIR
