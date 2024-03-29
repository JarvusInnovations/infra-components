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
# | ENGINE_ENV           | Name of env to be used when querying engine configs
# | ENGINE_LOCAL_DIR     | Absolute path to directory which env paths are relative to and from which highest precedence .conf files are collected
# | ENGINE_ARTIFACTS_DIR | Absolute path to directory which artifact paths are relative to
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

export ENGINE_SYSTEM_DIR
export ENGINE_PROJECT_DIR
export ENGINE_ENV
export ENGINE_LOCAL_DIR
export ENGINE_ARTIFACTS_DIR
export ENGINE_PIPELINES_DIR
