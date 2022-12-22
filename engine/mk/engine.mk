-include local.mk

ifeq ($(MK),)
MK                   := $(shell dirname '$(lastword $(MAKEFILE_LIST))')
endif

ifeq ($(ENGINE_SYSTEM_DIR),)
ENGINE_SYSTEM_DIR    := $(shell realpath '$(MK)/..')
endif

ifeq ($(ENGINE_PROJECT_DIR),)
ENGINE_PROJECT_DIR   := $(shell realpath '$(MK)/../..')
endif

ifeq ($(ENGINE_ENV),)
ENGINE_ENV           := local
endif

ifeq ($(ENGINE_ENV_DIR),)
ENGINE_ENV_DIR       := $(shell realpath `git rev-parse --git-path engine/env`)
endif

ifeq ($(ENGINE_ARTIFACTS_DIR),)
ENGINE_ARTIFACTS_DIR := $(shell realpath `git rev-parse --git-path engine/artifacts`)
endif

ifeq ($(ENGINE_PIPELINES_DIR),)
ENGINE_PIPELINES_DIR := $(ENGINE_PROJECT_DIR)/pipelines
endif

# call signature : $(call env_pathjoin,<subpath>)
# returns        : <engine-env-dir>/<subpath>
env_pathjoin     = $(ENGINE_ENV_DIR)/$(1)

# call signature : $(call env_pathstrip,<env-path>)
# returns        : <env-subpath>
env_pathstrip    = $(patsubst $(ENGINE_ENV_DIR)/%,%,$(1))

# call signature : $(call home_pathjoin,<subpath>)
# returns        : <engine-home>/<subpath>
home_pathjoin    = $(ENGINE_PROJECT_DIR)/$(1)

# call signature : $(call home_pathstrip,<home-path>)
# returns        : <home-subpath>
home_pathstrip   = $(patsubst $(ENGINE_PROJECT_DIR)/%,%,$(1))

# call signature : $(call artifact_pathjoin,<subpath>)
# returns        : <engine-artifacts-dir>/<subpath>
artifact_pathjoin  = $(ENGINE_ARTIFACTS_DIR)/$(1)

# call signature : $(call artifact_pathstrip,<artifact-path>)
# returns        : <artifact-subpath>
artifact_pathstrip = $(patsubst $(ENGINE_ARTIFACTS_DIR)/%,%,$(1))

export ENGINE_SYSTEM_DIR
export ENGINE_PROJECT_DIR
export ENGINE_ENV
export ENGINE_ENV_DIR
export ENGINE_ARTIFACTS_DIR
export ENGINE_PIPELINES_DIR
