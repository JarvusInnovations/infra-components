include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME := $(shell basename "`realpath .`")
endif

ifeq ($(DO_STAGES),)
DO_STAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
endif

export PIPELINE_NAME

$(info STARTUP: ENGINE_ENV=$(ENGINE_ENV))
$(info STARTUP: ENGINE_PROJECT_DIR=$(ENGINE_PROJECT_DIR))
$(info STARTUP: ENGINE_LOCAL_DIR=$(ENGINE_LOCAL_DIR))
$(info STARTUP: ENGINE_ARTIFACTS_DIR=$(ENGINE_ARTIFACTS_DIR))
$(shell mkdir -pv '$(ENGINE_LOCAL_DIR)'     >&2)
$(shell mkdir -pv '$(ENGINE_ARTIFACTS_DIR)' >&2)

run_stage = $(if $(filter $(1), $(DO_STAGES)), $(MAKE) -C $(1) stage)

help:
pipeline:

.PHONY: help
.PHONY: pipeline
