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
ENGINE_ENV_DIR  := $(shell git rev-parse --absolute-git-dir)/engine
endif

ifeq ($(LIFECYCLE_HOME),)
LIFECYCLE_HOME  := $(ENGINE_HOME)/lifecycles
endif

export ENGINE_SYSTEM
export ENGINE_HOME
export ENGINE_ENV_DIR
export LIFECYCLE_HOME