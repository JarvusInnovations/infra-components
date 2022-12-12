include $(dir $(lastword $(MAKEFILE_LIST)))/engine.mk

ifeq ($(PIPELINE_NAME),)
PIPELINE_NAME := $(shell basename "`realpath .`")
endif

ifeq ($(PIPELINE_DIR),)
PIPELINE_DIR  := $(PIPELINES_HOME)/$(PIPELINE_NAME)
endif

ifeq ($(SELECT_STAGES),)
SELECT_STAGES := $(shell find . -mindepth 1 -maxdepth 1 -type d ! -name '.*' -exec basename {} \;)
endif

export PIPELINE_NAME
export PIPELINE_DIR

$(info STARTUP: ENGINE_ENV=$(ENGINE_ENV))
$(info STARTUP: ENGINE_ENV_DIR=$(ENGINE_ENV_DIR))

run_stage = $(if $(filter $(1), $(SELECT_STAGES)), $(MAKE) -C $(1) stage)

pipeline:
help:

.PHONY: pipeline
.PHONY: help
