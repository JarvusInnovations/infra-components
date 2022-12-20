include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME := $(shell basename "`realpath .`")
endif

ifeq ($(PIPELINE_DIR),)
PIPELINE_DIR  := $(ENGINE_PIPELINES_DIR)/$(PIPELINE_NAME)
endif

ifeq ($(DO_STAGES),)
DO_STAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
endif

export PIPELINE_NAME
export PIPELINE_DIR

$(info STARTUP: ENGINE_ENV=$(ENGINE_ENV))
$(info STARTUP: ENGINE_ENV_DIR=$(ENGINE_ENV_DIR))
$(info STARTUP: ENGINE_PROJECT_DIR=$(ENGINE_PROJECT_DIR))

run_stage = $(if $(filter $(1), $(DO_STAGES)), $(MAKE) -C $(1) stage)

help:
pipeline:

.PHONY: help
.PHONY: pipeline
