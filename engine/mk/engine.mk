-include local.mk

ifeq ($(MK),)
MK              := $(shell dirname '$(lastword $(MAKEFILE_LIST))')
endif

ifeq ($(ENGINE_SYSTEM),)
ENGINE_SYSTEM   := $(shell realpath '$(MK)/..')
endif

ifeq ($(ENGINE_HOME),)
ENGINE_HOME     := $(shell realpath '$(MK)/../..')
endif

ifeq ($(ENGINE_ENV),)
ENGINE_ENV      := local
endif

ifeq ($(ENGINE_ENV_DIR),)
ENGINE_ENV_DIR  := $(shell realpath `git rev-parse --git-path engine`)
endif

ifeq ($(PIPELINES_HOME),)
PIPELINES_HOME  := $(ENGINE_HOME)/pipelines
endif

# call signature : $(call env_pathjoin,<subpath>)
# returns        : <engine-env-dir>/<subpath>
env_pathjoin     = $(ENGINE_ENV_DIR)/$(1)

# call signature : $(call env_pathstrip,<env-path>)
# returns        : <env-subpath>
env_pathstrip    = $(patsubst $(ENGINE_ENV_DIR)/%,%,$(1))

export ENGINE_SYSTEM
export ENGINE_HOME
export ENGINE_ENV_DIR
export PIPELINES_HOME
